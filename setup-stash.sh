#!/bin/bash
# 실습용 stash 자동 생성

echo "📦 실습용 stash를 생성합니다..."

# 현재 브랜치 저장
original_branch=$(git branch --show-current)

# ===========================================
# Stash 1: 사용자 인증 기능 작업 중
# ===========================================
git checkout main 2>/dev/null || git checkout -b main

# 디렉토리 생성
mkdir -p temp-stash-practice/src temp-stash-practice/tests temp-stash-practice/api

cat > temp-stash-practice/src/auth.js << 'EOF'
// 사용자 인증 로직
function login(username, password) {
    // TODO: 비밀번호 암호화 추가
    // TODO: JWT 토큰 생성
    return authenticateUser(username, password);
}

function logout() {
    // TODO: 토큰 무효화
}
EOF

cat > temp-stash-practice/src/user.js << 'EOF'
// 사용자 정보 관리
class User {
    constructor(username, email) {
        this.username = username;
        this.email = email;
        // TODO: 프로필 이미지 필드 추가
    }

    // TODO: 이메일 검증 메서드 추가
}
EOF

cat > temp-stash-practice/tests/auth.test.js << 'EOF'
// 인증 테스트
describe('Auth', () => {
    it('should login successfully', () => {
        // TODO: 테스트 케이스 작성
    });
});
EOF

git add temp-stash-practice/
git stash push -m "사용자 인증 기능 구현 중"

# ===========================================
# Stash 2: API 엔드포인트 추가 작업
# ===========================================
git checkout -b feature/api-endpoint 2>/dev/null || git checkout feature/api-endpoint

# 디렉토리 다시 생성 (stash 후 사라짐)
mkdir -p temp-stash-practice/src temp-stash-practice/tests temp-stash-practice/api

cat > temp-stash-practice/api/users.js << 'EOF'
// 사용자 API 엔드포인트
router.get('/api/users', async (req, res) => {
    // TODO: 페이지네이션 추가
    // TODO: 필터링 로직 추가
    const users = await User.findAll();
    res.json(users);
});

router.post('/api/users', async (req, res) => {
    // TODO: 입력 검증 추가
    const user = await User.create(req.body);
    res.json(user);
});
EOF

cat > temp-stash-practice/api/posts.js << 'EOF'
// 게시글 API
router.get('/api/posts', async (req, res) => {
    // TODO: 작성자 정보 포함
    const posts = await Post.findAll();
    res.json(posts);
});
EOF

git add temp-stash-practice/
git stash push -m "API 엔드포인트 추가 중"

# ===========================================
# Stash 3: 로그인 버그 수정
# ===========================================
git checkout -b fix/login-bug 2>/dev/null || git checkout fix/login-bug

# 디렉토리 다시 생성
mkdir -p temp-stash-practice/src temp-stash-practice/tests

cat > temp-stash-practice/src/auth.js << 'EOF'
// 사용자 인증 로직 (버그 수정 중)
function login(username, password) {
    // FIX: null 체크 추가
    if (!username || !password) {
        throw new Error('Username and password are required');
    }

    // FIX: 빈 문자열 체크
    if (username.trim() === '' || password.trim() === '') {
        throw new Error('Username and password cannot be empty');
    }

    return authenticateUser(username, password);
}
EOF

cat > temp-stash-practice/tests/auth.test.js << 'EOF'
// 인증 테스트 (버그 수정 검증)
describe('Auth - Bug Fix', () => {
    it('should reject null username', () => {
        expect(() => login(null, 'password')).toThrow();
    });

    it('should reject empty password', () => {
        expect(() => login('user', '')).toThrow();
    });
});
EOF

git add temp-stash-practice/
git stash push -m "로그인 null 체크 버그 수정 중"

# ===========================================
# Stash 4: 대규모 리팩토링
# ===========================================
git checkout main

# 디렉토리 다시 생성
mkdir -p temp-stash-practice/src

cat > temp-stash-practice/src/utils.js << 'EOF'
// 유틸리티 함수 (리팩토링 중)

// REFACTOR: 에러 핸들링 통일
export function handleError(error) {
    console.error('[ERROR]', error.message);
    // TODO: 로깅 서비스로 전송
    // TODO: 사용자 친화적 메시지 변환
}

// REFACTOR: 날짜 포맷팅 함수 분리
export function formatDate(date) {
    // TODO: 타임존 처리
    return new Date(date).toISOString();
}

// REFACTOR: 검증 로직 통일
export function validateEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}
EOF

cat > temp-stash-practice/src/config.js << 'EOF'
// 설정 파일 (리팩토링 중)
// REFACTOR: 환경변수로 분리 예정
export const config = {
    apiUrl: process.env.API_URL || 'http://localhost:3000',
    jwtSecret: process.env.JWT_SECRET || 'temp-secret', // TODO: 보안 강화
    sessionTimeout: 3600,
};
EOF

git add temp-stash-practice/
git stash push -m "유틸리티 함수 리팩토링 진행 중"

# ===========================================
# Stash 5: 성능 최적화
# ===========================================
git checkout -b perf/optimize-queries 2>/dev/null || git checkout perf/optimize-queries

# 디렉토리 다시 생성
mkdir -p temp-stash-practice/src temp-stash-practice/api

cat > temp-stash-practice/api/users.js << 'EOF'
// 사용자 API (성능 최적화 중)
router.get('/api/users', async (req, res) => {
    // PERF: N+1 쿼리 문제 해결
    const users = await User.findAll({
        include: [
            { model: Profile, attributes: ['avatar', 'bio'] },
            { model: Post, attributes: ['id'], limit: 5 }
        ],
        attributes: { exclude: ['password'] } // PERF: 불필요한 필드 제외
    });

    // PERF: 캐싱 추가 예정
    res.json(users);
});
EOF

cat > temp-stash-practice/src/cache.js << 'EOF'
// 캐싱 레이어 추가 중
class Cache {
    constructor() {
        this.store = new Map();
        // TODO: Redis 연동
    }

    get(key) {
        // TODO: TTL 체크
        return this.store.get(key);
    }

    set(key, value, ttl = 300) {
        // TODO: TTL 구현
        this.store.set(key, value);
    }
}
EOF

git add temp-stash-practice/
git stash push -m "데이터베이스 쿼리 최적화 작업 중"

# 원래 브랜치로 복귀
git checkout "$original_branch" 2>/dev/null

echo ""
echo "✅ 완료! 이제 git stash list를 확인해보세요:"
echo ""
git stash list | head -5
echo ""
echo "💡 팁: temp-stash-practice 폴더는 실습용 임시 폴더입니다."
echo "💡 총 5개의 새로운 stash가 생성되었습니다."