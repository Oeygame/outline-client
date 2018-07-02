#!/bin/bash -eu
#
# Copyright 2018 The Outline Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Same as package, except:
#  - prod Sentry keys are used
#  - the binary is signed (you'll need the hardware token, its password,
#    and a real Windows box)

yarn do electron/build

cp package.json build/windows/
scripts/environment_json.sh -p windows -r > build/windows/www/environment.json

# Copy tap-windows6.
cp -R third_party/tap-windows6/bin build/windows/tap-windows6

electron-builder \
  --projectDir=build/windows \
  --config.asarUnpack=electron/bin \
  --ia32 \
  --publish=never \
  --config.publish.provider=generic \
  --config.publish.url=https://raw.githubusercontent.com/Jigsaw-Code/outline-releases/windows-testers/client/ \
  --win nsis \
  --config.nsis.perMachine=true \
  --config.nsis.include=electron/custom_install_steps.nsh \
  --config.win.icon=icons/win/icon.ico \
  --config.win.certificateSubjectName='Jigsaw Operations LLC' \
  --config.nsis.artifactName='Outline-Client.${ext}'
