#bin/sh

git checkout master
git pull origin master
export BUILD_COMMIT_HASH=$(git rev-parse HEAD)

docker buildx build \
    --platform linux/amd64 \
    -f ./Dockerfile-sidekiq \
    -t 284976415069.dkr.ecr.us-east-1.amazonaws.com/naturesflavors-sidekiq-production:${BUILD_COMMIT_HASH} \
    --push .
    