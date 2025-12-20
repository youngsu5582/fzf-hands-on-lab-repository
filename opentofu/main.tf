# Get latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.instance_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.instance_name}-igw"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "${var.instance_name}-public-subnet"
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.instance_name}-public-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create Security Group
resource "aws_security_group" "instance" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = aws_vpc.main.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # HTTP access for Spring Boot
  ingress {
    description = "Spring Boot Application"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

# Create EC2 Instance
resource "aws_instance" "main" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = aws_subnet.public.id

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              apt-get update -y
              DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

              # Install basic tools
              apt-get install -y git vim htop curl wget unzip zip

              # Install zsh
              apt-get install -y zsh

              # Install fzf
              git clone --depth 1 https://github.com/junegunn/fzf.git /opt/fzf
              /opt/fzf/install --all --no-bash --no-fish

              # Create symlink for all users
              ln -sf /opt/fzf/bin/fzf /usr/local/bin/fzf

              # Setup for ubuntu user
              sudo -u ubuntu bash <<'USEREOF'
              # Install Oh My Zsh for ubuntu
              export RUNZSH=no
              export KEEP_ZSHRC=yes
              sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

              # Add fzf to .zshrc
              if [ -f ~/.zshrc ]; then
                echo '' >> ~/.zshrc
                echo '# fzf integration' >> ~/.zshrc
                echo '[ -f /opt/fzf/shell/key-bindings.zsh ] && source /opt/fzf/shell/key-bindings.zsh' >> ~/.zshrc
                echo '[ -f /opt/fzf/shell/completion.zsh ] && source /opt/fzf/shell/completion.zsh' >> ~/.zshrc
              fi
              USEREOF

              # Change default shell for ubuntu to zsh
              chsh -s /bin/zsh ubuntu

              # Install SDKMAN for ubuntu user
              sudo -u ubuntu bash <<'SDKEOF'
              # Install SDKMAN
              curl -s "https://get.sdkman.io" | bash
              source "$HOME/.sdkman/bin/sdkman-init.sh"

              # Install Java 21 LTS
              sdk install java 21.0.1-tem < /dev/null

              # Install Gradle
              sdk install gradle 8.5 < /dev/null

              # Clone sample-server
              cd ~
              git clone https://github.com/youngsu5582/fzf-hands-on-lab-repository.git

              # Build sample-server
              cd ~/fzf-hands-on-lab-repository/sample-server
              ./gradlew build --no-daemon

              # Create start script
              cat > ~/start-server.sh <<'STARTSCRIPT'
#!/bin/bash
cd ~/fzf-hands-on-lab-repository/sample-server
source "$HOME/.sdkman/bin/sdkman-init.sh"
./gradlew bootRun
STARTSCRIPT

              chmod +x ~/start-server.sh

              # Add SDKMAN to .zshrc
              if [ -f ~/.zshrc ]; then
                echo '' >> ~/.zshrc
                echo '# SDKMAN' >> ~/.zshrc
                echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> ~/.zshrc
                echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.zshrc
              fi

              # Add to .bashrc as well
              if [ -f ~/.bashrc ]; then
                echo '' >> ~/.bashrc
                echo '# SDKMAN' >> ~/.bashrc
                echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> ~/.bashrc
                echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc
              fi
              SDKEOF

              echo "Setup completed successfully!" > /tmp/setup-complete.txt
              echo "Java, Gradle, and sample-server installed!" >> /tmp/setup-complete.txt
              EOF

  tags = {
    Name = var.instance_name
  }
}
