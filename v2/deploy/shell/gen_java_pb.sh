#!/bin/sh

CUR_DIR=`cd ../../ && pwd`
API_USER_DIR=${CUR_DIR}/api/apiuser/api/user/v1
THIRD_PARTY_DIR=${CUR_DIR}/third_party

PROTOC_DIRS="
${API_USER_DIR}
"

echo "generate start..."
for dir in ${PROTOC_DIRS}; do
    for file in ${dir}/*.proto; do
        # go
        # protoc --proto_path=${dir} --proto_path=${CUR_DIR} --proto_path=${THIRD_PARTY_DIR} --go-grpc_out=${CUR_DIR} --go_out=${CUR_DIR} ${file}

        if [[ ! ${file} =~ "api_" ]]; then
          # java
          protoc --proto_path=${dir} --proto_path=${CUR_DIR} --proto_path=${THIRD_PARTY_DIR} --java_out=${CUR_DIR} ${file}
          echo "gen ${file} ok"
        fi

    done
done
echo "generate end!"