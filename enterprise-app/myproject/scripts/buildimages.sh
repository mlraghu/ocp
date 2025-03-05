#!/usr/bin/env bash
#   Copyright IBM Corporation 2021
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# Invoke as ./buildimages.sh <container_runtime>
# Examples:
# 1) ./buildimages.sh
# 2) ./buildimages.sh podman

if [[ "$(basename "$PWD")" != 'scripts' ]] ; then
  echo 'please run this script from the "scripts" directory'
  exit 1
fi
CONTAINER_RUNTIME=docker
if [ "$#" -eq 1 ]; then
    CONTAINER_RUNTIME=$1
fi
if [ "${CONTAINER_RUNTIME}" != "docker" ] && [ "${CONTAINER_RUNTIME}" != "podman" ]; then
   echo 'Unsupported container runtime passed as an argument for building the images: '"${CONTAINER_RUNTIME}"
   exit 1
fi
cd .. # go to the parent directory so that all the relative paths will be correct

echo 'building image customers-buildstage'
cd source/customers
${CONTAINER_RUNTIME} build -f Dockerfile.buildstage -t customers-buildstage .
cd -

echo 'building image gateway-buildstage'
cd source/gateway
${CONTAINER_RUNTIME} build -f Dockerfile.buildstage -t gateway-buildstage .
cd -

echo 'building image inventory-buildstage'
cd source/inventory
${CONTAINER_RUNTIME} build -f Dockerfile.buildstage -t inventory-buildstage .
cd -

echo 'building image orders-buildstage'
cd source/orders
${CONTAINER_RUNTIME} build -f Dockerfile.buildstage -t orders-buildstage .
cd -

echo 'building image frontend'
cd source/frontend
${CONTAINER_RUNTIME} build -f Dockerfile -t frontend .
cd -

echo 'building image gateway'
cd source/gateway
${CONTAINER_RUNTIME} build -f Dockerfile -t gateway .
cd -

echo 'building image inventory'
cd source/inventory
${CONTAINER_RUNTIME} build -f Dockerfile -t inventory .
cd -

echo 'building image orders'
cd source/orders
${CONTAINER_RUNTIME} build -f Dockerfile -t orders .
cd -

echo 'building image customers'
cd source/customers
${CONTAINER_RUNTIME} build -f Dockerfile -t customers .
cd -

echo 'done'
