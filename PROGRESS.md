# REI-Bench 진행상황 (앞으로 할 일)

## 구조 (분리 배포)
- **서버 (3090)**: 모델 서빙만 — vLLM이 `:8000`에서 Llama-3.1-8B 채점 담당 (현재 실행 중)
- **로컬 (4060)**: THOR + 평가 루프. 매 스텝 서버에 채점 요청 → best 스킬 받아 THOR 실행
- 연결: 로컬 → 서버 SSH 터널 (`localhost:8000` → 서버 vLLM)
- 이유: 2019 THOR 빌드가 헤드리스 서버에서 reset/Initialize hang → THOR는 로컬에서 실행

## 남은 작업

> 코드 패치(`task_planner.py` remote_url 분기)는 `ecf4dc6`로 커밋·푸시 완료.
> `config.yaml`은 HF 토큰 때문에 커밋하지 않음 — 로컬에서 직접 설정.

### 1. 로컬 셋업
- [ ] `git pull`로 `task_planner.py` 패치 받기
- [ ] `configs/config.yaml` planner 섹션에 `remote_url: "http://localhost:8000"` 추가
- [ ] 데이터 로컬로 — `data/raw/alfred/json_2.1.0`(pp/ann 포함) + `data/rei_bench/splits/rei_bench.json` (scp 또는 전처리 재실행)
- [ ] 의존성 확인 (ai2thor, requests 등 — 로컬은 모델 로딩 안 하므로 GPU 모델 불필요)

### 2. 실행
- [ ] SSH 터널: `ssh -N -L 8000:localhost:8000 jimin@115.145.173.17`
- [ ] 로컬에서 THOR 디스플레이 확인
- [ ] `python scripts/evaluate.py` 실행
- [ ] 첫 태스크가 정상 동작(plan → THOR 실행 → 결과 피드백)하는지 확인

### 3. 검증
- [ ] 9개 data_type 평가 완료
- [ ] success rate 결과 확인
