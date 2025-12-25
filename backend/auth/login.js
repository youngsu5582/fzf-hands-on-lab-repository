// 사용자 로그인 처리
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

async function login(username, password) {
  const user = await User.findOne({ username });

  if (!user) {
    throw new Error('User not found');
  }

  const isValid = await bcrypt.compare(password, user.passwordHash);

  if (!isValid) {
    throw new Error('Invalid password');
  }

  const token = jwt.sign(
    { userId: user.id, username: user.username },
    process.env.JWT_SECRET,
    { expiresIn: '24h' }
  );

  return { token, user: { id: user.id, username: user.username } };
}

module.exports = { login };
