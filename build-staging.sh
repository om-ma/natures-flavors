#bin/sh

source .set-build-env-staging
cp ./.env-staging-naturesflavors ./.env

if [ "$#" -eq  "0" ]
then
    git checkout staging
    git pull origin staging
else
    git checkout $1
    git pull origin $1
fi

export BUILD_COMMIT_HASH=$(git rev-parse HEAD)

docker buildx build \
    --platform linux/amd64 \
    --build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    --build-arg AWS_SECRET_KEY=${AWS_SECRET_KEY} \
    --build-arg S3_ASSET_REGION=${S3_ASSET_REGION} \
    --build-arg S3_ASSET_BUCKET=${S3_ASSET_BUCKET} \
    --build-arg SECRET_KEY_BASE=${SECRET_KEY_BASE} \
    -f ./Dockerfile-staging \
    -t 284976415069.dkr.ecr.us-east-1.amazonaws.com/naturesflavors-staging:${BUILD_COMMIT_HASH} \
    --push .

source .set-build-env-clear
cp ./.env-development-naturesflavors ./.env