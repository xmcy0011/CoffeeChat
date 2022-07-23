#!/bin/sh

CUR_DIR=`cd ../ && pwd`
CHAT_DIR=${CUR_DIR}/api/chat
THIRD_PARTY_DIR=${CUR_DIR}/third_party
OUT_OPENAPI_DIR=${CUR_DIR}

PROTO_DIRS="
${CHAT_DIR}
"

echo "gen start..."
for dir in ${PROTO_DIRS}; do
    for file in ${dir}/*.proto; do
        # --openapi_out=${OUT_OPENAPI_DIR} \
        protoc --proto_path=${dir} --proto_path=${CUR_DIR} --proto_path=${THIRD_PARTY_DIR} \
               --go-grpc_out=${CUR_DIR} --go-http_out=${CUR_DIR} \
               --openapiv2_out . --openapiv2_opt logtostderr=true --openapiv2_opt json_names_for_fields=false \
               --go_out=${CUR_DIR} ${file}
        echo "gen ${file} ok"
    done
done
echo "gen end!"