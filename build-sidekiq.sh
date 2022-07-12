#bin/sh

cp ./.env-production-naturesflavors ./.env
git checkout master
export BUILD_COMMIT_HASH=$(git rev-parse HEAD)
docker-compose -f docker-compose-sidekiq.yml build
docker-compose -f docker-compose-sidekiq.yml push app
cp ./.env-development-naturesflavors ./.env
