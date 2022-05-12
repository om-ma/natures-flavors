#bin/sh

cp ./.env-staging-naturesflavors ./.env
git checkout staging
export BUILD_COMMIT_HASH=$(git rev-parse HEAD)
docker-compose -f docker-compose-staging.yml build
docker-compose -f docker-compose-staging.yml push app
cp ./.env-development-naturesflavors ./.env
