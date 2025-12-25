// 사용자 프로필 컨트롤러 (버그 수정)

async function getUserProfile(req, res) {
  try {
    const user = await User.findById(req.params.id);

    // FIX: null 체크 추가
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // FIX: profile이 없을 경우 기본값 반환
    const profile = user.profile || {
      bio: '',
      avatar: '/default-avatar.png',
      location: ''
    };

    res.json({
      id: user.id,
      username: user.username,
      email: user.email,
      profile
    });
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

async function updateUserProfile(req, res) {
  try {
    const user = await User.findById(req.user.id);

    // FIX: 사용자 존재 확인
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // FIX: profile 객체가 없으면 초기화
    if (!user.profile) {
      user.profile = {};
    }

    // 안전하게 업데이트
    user.profile.bio = req.body.bio || user.profile.bio;
    user.profile.avatar = req.body.avatar || user.profile.avatar;
    user.profile.location = req.body.location || user.profile.location;

    await user.save();

    res.json({ message: 'Profile updated', profile: user.profile });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = { getUserProfile, updateUserProfile };
