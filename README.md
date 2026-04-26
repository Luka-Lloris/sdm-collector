# sdm-collector

ẞDM 백엔드의 공고 수집 트리거 워커.

GitHub Actions cron으로 정기 실행되며, Railway에 배포된 ẞDM 백엔드 API를 호출해 수집을 시작시킵니다.
실제 수집 로직(API 호출·파싱·DB 저장)은 백엔드(`sdm-backend`)에서 동작합니다.

## 구조

```
.github/workflows/
└── bizinfo.yml          # 일 2회 (KST 05:00, 15:30)
scripts/
└── trigger.sh           # 로컬 수동 호출용
```

## 동작 흐름

```
GitHub Actions (KST 05:00, 15:30)
    ↓
curl POST → Railway API
    ↓
ẞDM Backend
    ├── Bizinfo API 호출 (8개 카테고리 페이지네이션)
    ├── parse_items() — 룰베이스 추론
    └── upsert_opportunities() — Supabase ON CONFLICT
```

## Secrets 설정

GitHub 레포 Settings → Secrets and variables → Actions

| Name | 값 |
|------|------|
| `RAILWAY_API_URL` | Railway 백엔드 URL (예: `https://web-production-c8d70c.up.railway.app`) |
| `RAILWAY_ADMIN_TOKEN` | 백엔드 `ADMIN_TOKEN` 환경변수와 매칭되는 값 |

## 수동 트리거

```bash
RAILWAY_API_URL=https://... \
RAILWAY_ADMIN_TOKEN=... \
./scripts/trigger.sh bizinfo
```

## 향후 추가 예정

- `g2b.yml` — 나라장터
- `ntis.yml` — 국가과학기술정보
- `kised.yml` — 창업진흥원
- `kosme.yml` — 중소벤처기업진흥공단
- `nipa.yml` — 정보통신산업진흥원
- `seoul_startup.yml` — 서울창업허브
