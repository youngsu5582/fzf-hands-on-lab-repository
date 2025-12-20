#!/bin/bash
# 실습용 PR 자동 생성 스크립트 (실제 개발 시나리오)

set -e

echo "🔧 실습용 PR을 생성합니다..."
echo ""

# 현재 브랜치 저장
original_branch=$(git branch --show-current)

# GitHub CLI 확인
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh)가 설치되어 있지 않습니다."
    echo "설치: brew install gh"
    exit 1
fi

# GitHub 인증 확인
if ! gh auth status &> /dev/null; then
    echo "❌ Error: GitHub 인증이 필요합니다."
    echo "실행: gh auth login"
    exit 1
fi

echo "✅ 사전 체크 완료"
echo ""

# ===========================================
# PR 1: 사용자 인증 기능 추가
# ===========================================
echo "📝 PR #1: 사용자 인증 기능 추가"

git checkout main 2>/dev/null
git checkout -b feature/user-authentication 2>/dev/null || git checkout feature/user-authentication

mkdir -p backend/auth backend/middleware

cat > backend/auth/login.js << 'EOF'
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
EOF

cat > backend/middleware/auth.js << 'EOF'
// JWT 인증 미들웨어
const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.sendStatus(401);
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.sendStatus(403);
    }
    req.user = user;
    next();
  });
}

module.exports = { authenticateToken };
EOF

cat > backend/auth/register.js << 'EOF'
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
EOF

git add backend/
git commit -m "feat: 사용자 인증 기능 구현

- JWT 기반 로그인/회원가입 추가
- bcrypt로 비밀번호 해싱
- 인증 미들웨어 구현
- 토큰 만료 시간 24시간 설정"

git push -u origin feature/user-authentication --force

gh pr create \
    --title "feat: 사용자 인증 시스템 구현" \
    --body "## 변경 사항
JWT 기반 사용자 인증 시스템 구현

### 구현 내용
- ✅ 로그인 API
- ✅ 회원가입 API
- ✅ JWT 토큰 발급
- ✅ 인증 미들웨어
- ✅ bcrypt 비밀번호 해싱

### API 엔드포인트
\`\`\`
POST /api/auth/login
POST /api/auth/register
\`\`\`

### 테스트
- [ ] 로그인 성공 케이스
- [ ] 로그인 실패 케이스
- [ ] 회원가입 유효성 검증
- [ ] 토큰 검증 미들웨어

### 보안
- bcrypt salt rounds: 10
- JWT 만료: 24시간
- 환경변수로 secret 관리" \
    --base main 2>/dev/null || echo "PR already exists"

echo "✅ PR #1 생성 완료"
echo ""

# ===========================================
# PR 2: 버그 수정 - null pointer exception
# ===========================================
echo "📝 PR #2: 버그 수정 - null pointer exception"

git checkout main 2>/dev/null
git checkout -b fix/null-pointer-in-user-profile 2>/dev/null || git checkout fix/null-pointer-in-user-profile

mkdir -p backend/controllers

cat > backend/controllers/userController.js << 'EOF'
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
EOF

git add backend/controllers/
git commit -m "fix: null pointer exception in user profile

- 사용자가 없을 때 404 반환
- profile 객체가 없을 때 기본값 반환
- null 체크 추가
- 에러 핸들링 개선

Fixes #234"

git push -u origin fix/null-pointer-in-user-profile --force

gh pr create \
    --title "fix: 사용자 프로필 null pointer exception 수정" \
    --body "## 문제
사용자 프로필이 없을 때 null pointer exception 발생

### 재현 방법
1. 새로운 사용자 생성
2. \`GET /api/users/:id/profile\` 호출
3. 500 에러 발생

## 해결
- 사용자 존재 확인 추가
- profile 객체 null 체크
- 기본값 반환 로직 추가
- 에러 핸들링 개선

## 변경 사항
\`\`\`javascript
// Before
const profile = user.profile;  // null일 수 있음

// After
const profile = user.profile || { /* defaults */ };
\`\`\`

## 테스트
- [x] 프로필이 없는 사용자 조회
- [x] 프로필이 있는 사용자 조회
- [x] 존재하지 않는 사용자 조회
- [x] 프로필 업데이트

Closes #234" \
    --base main 2>/dev/null || echo "PR already exists"

echo "✅ PR #2 생성 완료"
echo ""

# ===========================================
# PR 3: 성능 개선 - 데이터베이스 쿼리 최적화
# ===========================================
echo "📝 PR #3: 성능 개선 - 데이터베이스 쿼리"

git checkout main 2>/dev/null
git checkout -b perf/optimize-database-queries 2>/dev/null || git checkout perf/optimize-database-queries

mkdir -p backend/services

cat > backend/services/postService.js << 'EOF'
// 게시글 서비스 (성능 최적화)

// BEFORE: N+1 쿼리 문제
// async function getPosts() {
//   const posts = await Post.find();
//   for (let post of posts) {
//     post.author = await User.findById(post.authorId);
//   }
//   return posts;
// }

// AFTER: JOIN으로 한 번에 조회
async function getPosts(page = 1, limit = 20) {
  const skip = (page - 1) * limit;

  const posts = await Post.find()
    .populate('author', 'username avatar')  // PERF: JOIN으로 최적화
    .populate('comments', 'content createdAt')
    .select('-__v')  // PERF: 불필요한 필드 제외
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limit)
    .lean();  // PERF: plain object 반환으로 성능 향상

  return posts;
}

// 인덱스 추가 필요
// db.posts.createIndex({ createdAt: -1 })
// db.posts.createIndex({ authorId: 1 })

async function getPostById(id) {
  // PERF: 캐싱 추가 예정
  const cacheKey = `post:${id}`;

  // TODO: Redis 캐시 확인

  const post = await Post.findById(id)
    .populate('author', 'username avatar bio')
    .populate({
      path: 'comments',
      populate: { path: 'author', select: 'username avatar' }
    })
    .lean();

  // TODO: Redis에 캐시 저장

  return post;
}

module.exports = { getPosts, getPostById };
EOF

cat > backend/config/database.js << 'EOF'
// 데이터베이스 설정 (성능 최적화)

const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI, {
  // PERF: 연결 풀 최적화
  maxPoolSize: 10,
  minPoolSize: 2,

  // PERF: 타임아웃 설정
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,

  // PERF: 자동 인덱스 생성 (프로덕션에서는 false)
  autoIndex: process.env.NODE_ENV !== 'production'
});

// 쿼리 실행 시간 로깅
if (process.env.NODE_ENV === 'development') {
  mongoose.set('debug', (collectionName, method, query, doc) => {
    console.log(`${collectionName}.${method}`, JSON.stringify(query), doc);
  });
}

module.exports = mongoose;
EOF

git add backend/services/ backend/config/
git commit -m "perf: 데이터베이스 쿼리 최적화

- N+1 쿼리 문제 해결 (populate 사용)
- 불필요한 필드 제외 (select)
- lean() 사용으로 성능 향상
- 페이지네이션 추가
- 연결 풀 최적화
- 쿼리 실행 시간 로깅 추가

성능 향상: 응답 시간 500ms → 50ms (10배)"

git push -u origin perf/optimize-database-queries --force

gh pr create \
    --title "perf: 데이터베이스 쿼리 성능 10배 개선" \
    --body "## 성능 문제
게시글 목록 조회 시 N+1 쿼리 발생으로 응답 시간이 느림

### 측정 결과
| 항목 | Before | After | 개선율 |
|------|--------|-------|--------|
| 응답 시간 | 500ms | 50ms | **10배** |
| DB 쿼리 수 | 101회 | 1회 | **99% 감소** |

## 최적화 내용

### 1. N+1 쿼리 해결
\`\`\`javascript
// Before: 101번의 쿼리
const posts = await Post.find();  // 1회
for (let post of posts) {
  post.author = await User.findById(post.authorId);  // 100회
}

// After: 1번의 쿼리
const posts = await Post.find()
  .populate('author', 'username avatar');  // JOIN
\`\`\`

### 2. 불필요한 데이터 제거
- \`select('-__v')\`: 버전 필드 제외
- \`lean()\`: Mongoose 객체 → Plain Object

### 3. 연결 풀 최적화
- maxPoolSize: 10
- minPoolSize: 2

### 4. 페이지네이션 추가
- 한 번에 20개씩만 조회

## 인덱스 추가 필요
\`\`\`javascript
db.posts.createIndex({ createdAt: -1 })
db.posts.createIndex({ authorId: 1 })
\`\`\`

## 테스트
- [x] 100개 게시글 조회 성능 테스트
- [x] 1000개 게시글 조회 성능 테스트
- [x] 메모리 사용량 확인
- [ ] 프로덕션 환경 테스트" \
    --base main 2>/dev/null || echo "PR already exists"

echo "✅ PR #3 생성 완료"
echo ""

# ===========================================
# PR 4: UI 개선 - 다크모드 지원
# ===========================================
echo "📝 PR #4: UI 개선 - 다크모드"

git checkout main 2>/dev/null
git checkout -b feature/dark-mode-support 2>/dev/null || git checkout feature/dark-mode-support

mkdir -p frontend/styles frontend/hooks

cat > frontend/styles/theme.css << 'EOF'
/* 다크모드 테마 */

:root {
  /* Light mode (default) */
  --bg-primary: #ffffff;
  --bg-secondary: #f5f5f5;
  --text-primary: #333333;
  --text-secondary: #666666;
  --border-color: #e0e0e0;
  --button-primary: #007bff;
  --button-hover: #0056b3;
}

[data-theme='dark'] {
  /* Dark mode */
  --bg-primary: #1a1a1a;
  --bg-secondary: #2d2d2d;
  --text-primary: #ffffff;
  --text-secondary: #b0b0b0;
  --border-color: #404040;
  --button-primary: #4a9eff;
  --button-hover: #357abd;
}

body {
  background-color: var(--bg-primary);
  color: var(--text-primary);
  transition: background-color 0.3s ease, color 0.3s ease;
}

.card {
  background-color: var(--bg-secondary);
  border: 1px solid var(--border-color);
}

button {
  background-color: var(--button-primary);
  color: white;
}

button:hover {
  background-color: var(--button-hover);
}
EOF

cat > frontend/hooks/useDarkMode.js << 'EOF'
// 다크모드 커스텀 훅
import { useState, useEffect } from 'react';

export function useDarkMode() {
  const [theme, setTheme] = useState(() => {
    // 로컬 스토리지에서 테마 불러오기
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
      return savedTheme;
    }

    // 시스템 설정 확인
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }

    return 'light';
  });

  useEffect(() => {
    // 테마 적용
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return { theme, toggleTheme };
}
EOF

cat > frontend/components/ThemeToggle.jsx << 'EOF'
// 다크모드 토글 버튼
import React from 'react';
import { useDarkMode } from '../hooks/useDarkMode';

export function ThemeToggle() {
  const { theme, toggleTheme } = useDarkMode();

  return (
    <button
      onClick={toggleTheme}
      className="theme-toggle"
      aria-label="Toggle dark mode"
    >
      {theme === 'light' ? '🌙' : '☀️'}
    </button>
  );
}
EOF

git add frontend/
git commit -m "feat: 다크모드 지원 추가

- CSS 변수 기반 테마 시스템
- useDarkMode 커스텀 훅
- 로컬 스토리지에 선택 저장
- 시스템 설정 자동 감지
- 부드러운 전환 애니메이션"

git push -u origin feature/dark-mode-support --force

gh pr create \
    --title "feat: 다크모드 지원 추가" \
    --body "## 기능
사용자가 라이트/다크 모드를 선택할 수 있는 기능 추가

## 구현 내용

### 1. CSS 변수 기반 테마
- 색상을 CSS 변수로 관리
- 테마 전환 시 모든 컴포넌트 자동 적용

### 2. useDarkMode 훅
- 테마 상태 관리
- 로컬 스토리지 저장
- 시스템 설정 자동 감지

### 3. ThemeToggle 컴포넌트
- 🌙/☀️ 이모지로 직관적 표시
- 클릭으로 즉시 전환

## 사용자 경험
- ✅ 선택한 테마가 저장되어 재방문 시 유지
- ✅ 시스템 다크모드 설정 자동 적용
- ✅ 부드러운 전환 애니메이션 (0.3s)

## 스크린샷
- Light mode: 깔끔한 화이트 배경
- Dark mode: 눈에 편한 다크 배경

## 테스트
- [x] 라이트 → 다크 전환
- [x] 다크 → 라이트 전환
- [x] 로컬 스토리지 저장 확인
- [x] 새로고침 후 테마 유지
- [x] 시스템 설정 감지" \
    --base main 2>/dev/null || echo "PR already exists"

echo "✅ PR #4 생성 완료"
echo ""

# ===========================================
# PR 5: 테스트 코드 추가
# ===========================================
echo "📝 PR #5: 테스트 코드 추가"

git checkout main 2>/dev/null
git checkout -b test/add-auth-tests 2>/dev/null || git checkout test/add-auth-tests

mkdir -p backend/tests

cat > backend/tests/auth.test.js << 'EOF'
// 인증 기능 테스트
const { login, register } = require('../auth');
const User = require('../models/User');

describe('Authentication', () => {
  beforeEach(async () => {
    await User.deleteMany({});
  });

  describe('회원가입', () => {
    it('새로운 사용자를 생성할 수 있다', async () => {
      const userData = {
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123'
      };

      const user = await register(userData.username, userData.email, userData.password);

      expect(user).toBeDefined();
      expect(user.username).toBe('testuser');
      expect(user.email).toBe('test@example.com');
      expect(user.passwordHash).toBeUndefined(); // 비밀번호는 반환하지 않음
    });

    it('중복된 사용자명은 거부한다', async () => {
      await register('testuser', 'test1@example.com', 'password123');

      await expect(
        register('testuser', 'test2@example.com', 'password456')
      ).rejects.toThrow('Username or email already exists');
    });

    it('중복된 이메일은 거부한다', async () => {
      await register('testuser1', 'test@example.com', 'password123');

      await expect(
        register('testuser2', 'test@example.com', 'password456')
      ).rejects.toThrow('Username or email already exists');
    });
  });

  describe('로그인', () => {
    beforeEach(async () => {
      await register('testuser', 'test@example.com', 'password123');
    });

    it('올바른 인증정보로 로그인할 수 있다', async () => {
      const result = await login('testuser', 'password123');

      expect(result).toBeDefined();
      expect(result.token).toBeDefined();
      expect(result.user.username).toBe('testuser');
    });

    it('잘못된 비밀번호는 거부한다', async () => {
      await expect(
        login('testuser', 'wrongpassword')
      ).rejects.toThrow('Invalid password');
    });

    it('존재하지 않는 사용자는 거부한다', async () => {
      await expect(
        login('nonexistent', 'password123')
      ).rejects.toThrow('User not found');
    });

    it('생성된 JWT 토큰은 유효하다', async () => {
      const result = await login('testuser', 'password123');
      const decoded = jwt.verify(result.token, process.env.JWT_SECRET);

      expect(decoded.username).toBe('testuser');
      expect(decoded.userId).toBeDefined();
    });
  });
});
EOF

cat > backend/tests/setup.js << 'EOF'
// 테스트 환경 설정
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();

  await mongoose.connect(mongoUri);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

afterEach(async () => {
  const collections = mongoose.connection.collections;

  for (const key in collections) {
    await collections[key].deleteMany();
  }
});
EOF

git add backend/tests/
git commit -m "test: 인증 기능 테스트 추가

- 회원가입 테스트 (성공, 중복 체크)
- 로그인 테스트 (성공, 실패)
- JWT 토큰 검증 테스트
- MongoDB Memory Server 사용
- 테스트 환경 분리

테스트 커버리지: 85%"

git push -u origin test/add-auth-tests --force

gh pr create \
    --title "test: 인증 기능 테스트 코드 추가" \
    --body "## 테스트 추가
인증 관련 기능의 단위 테스트 추가

## 테스트 범위

### 회원가입
- ✅ 정상 회원가입
- ✅ 중복 사용자명 검증
- ✅ 중복 이메일 검증

### 로그인
- ✅ 정상 로그인
- ✅ 잘못된 비밀번호
- ✅ 존재하지 않는 사용자
- ✅ JWT 토큰 유효성

## 테스트 환경
- Jest 테스트 프레임워크
- MongoDB Memory Server (인메모리 DB)
- 각 테스트 후 데이터 초기화

## 실행 방법
\`\`\`bash
npm test
npm run test:coverage
\`\`\`

## 커버리지
- Statements: 85%
- Branches: 80%
- Functions: 90%
- Lines: 85%

## 다음 단계
- [ ] 통합 테스트 추가
- [ ] E2E 테스트 추가
- [ ] CI/CD 파이프라인 연동" \
    --base main 2>/dev/null || echo "PR already exists"

echo "✅ PR #5 생성 완료"
echo ""

# 원래 브랜치로 복귀
git checkout "$original_branch" 2>/dev/null

echo ""
echo "========================================="
echo "  ✅ 실습용 PR 생성 완료!"
echo "========================================="
echo ""
echo "생성된 PR 목록:"
echo ""
gh pr list --limit 10 2>/dev/null || echo "gh pr list 실행 실패"
echo ""
echo "💡 팁:"
echo "  gh pr list | fzf --preview 'gh pr view {1}'"
echo "  gh pr checkout \$(gh pr list | fzf | awk '{print \$1}')"
echo ""
