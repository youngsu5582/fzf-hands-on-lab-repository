// 사용자 회원가입
const bcrypt = require('bcrypt');

async function register(username, email, password) {
  const existingUser = await User.findOne({ $or: [{ username }, { email }] });

  if (existingUser) {
    throw new Error('Username or email already exists');
  }

  const saltRounds = 10;
  const passwordHash = await bcrypt.hash(password, saltRounds);

  const user = await User.create({
    username,
    email,
    passwordHash,
    createdAt: new Date()
  });

  return { id: user.id, username: user.username, email: user.email };
}

module.exports = { register };
