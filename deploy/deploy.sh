#!/usr/bin/env bash
# GitHub Actions 가 SSH 로 실행하는 배포 스크립트 (서버: /srv/devgear/workout)
#   bash /srv/devgear/workout/deploy/deploy.sh
#
# 전체를 main 함수로 감싼다 — git pull 이 이 파일 자체를 바꿔도 bash 는 이미 읽은 함수를 끝까지 실행한다.
set -euo pipefail

main() {
    cd /srv/devgear/workout
    git pull --ff-only
    docker compose up -d --build

    # 컨테이너 HEALTHCHECK 가 healthy 가 될 때까지 최대 3분 기다린다. 안 되면 실패로 끝나 Actions 에 빨간불이 켜진다
    local status=""
    for _ in $(seq 36); do
        status=$(docker inspect --format '{{.State.Health.Status}}' workout)
        case "$status" in
            healthy)
                echo "배포 완료: $(git log --oneline -1)"
                return 0
                ;;
            unhealthy)
                break
                ;;
        esac
        sleep 5
    done

    echo "컨테이너가 정상 상태가 되지 않았습니다 (status=$status)" >&2
    docker compose logs --tail 80 app >&2
    return 1
}

main "$@"
exit
