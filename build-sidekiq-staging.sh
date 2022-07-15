#bin/sh

git checkout staging
git pull origin staging
export BUILD_COMMIT_HASH=$(git rev-parse HEAD)

docker buildx build \
    --platform linux/amd64 \
    -f ./Dockerfile-sidekiq-staging \
    -t 284976415069.dkr.ecr.us-east-1.amazonaws.com/naturesflavors-sidekiq-staging:${BUILD_COMMIT_HASH} \
    --push .
    