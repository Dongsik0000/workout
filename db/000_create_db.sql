-- postgres 슈퍼유저로 1회 실행:  sudo -u postgres psql -f db/000_create_db.sql
-- 비밀번호는 실행 전에 바꾼다 (서버 /etc/workout/app.env 의 WORKOUT_DB_PASSWORD 와 동일해야 함)
CREATE ROLE workout_app LOGIN PASSWORD 'workout_app';
CREATE DATABASE workout OWNER workout_app ENCODING 'UTF8';
