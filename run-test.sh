RETRY_REQUEST_VERSION=${1:-4.2.2}

SPANNER_GRPC_PORT=9010
SPANNER_HTTP_PORT=9020
export SPANNER_EMULATOR_HOST=localhost:${SPANNER_GRPC_PORT}
SPANNER_EMULATOR_REST_HOST=localhost:${SPANNER_HTTP_PORT}
GCLOUD_SDK_VERSION=346.0.0
export GOOGLE_CLOUD_PROJECT=demo-test

echo "Using retry-request ${RETRY_REQUEST_VERSION}"
npm install retry-request@${RETRY_REQUEST_VERSION} > /dev/null

docker rm -f spanner > /dev/null
docker run -d\
  --name spanner\
  -p 127.0.0.1:${SPANNER_GRPC_PORT}:${SPANNER_GRPC_PORT}\
  -p 127.0.0.1:${SPANNER_HTTP_PORT}:${SPANNER_HTTP_PORT}\
  gcr.io/google.com/cloudsdktool/cloud-sdk:${GCLOUD_SDK_VERSION}-emulators\
  gcloud beta emulators spanner start --host-port=0.0.0.0:${SPANNER_GRPC_PORT} --rest-port=${SPANNER_HTTP_PORT} --project=${GOOGLE_CLOUD_PROJECT} > /dev/null

sleep 5

node test.js
