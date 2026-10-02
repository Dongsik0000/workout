-- workout_app 으로 실행:  psql -U workout_app -d workout -f db/001_schema.sql
-- 모든 사용자 데이터 테이블은 user_id 로 격리한다. 조회 쿼리는 항상 AND user_id = #{userId} 를 건다.
-- 운동 기록 테이블은 다음 번호 파일(002_...sql)로 추가한다. 이미 적용한 파일은 고치지 않고 새 파일로 바꾼다.

CREATE TABLE app_user (
    id            BIGSERIAL PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT now()
);
