#!/bin/bash
#
# Copyright (C) 2019 crDroid Android Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#$1=TARGET_DEVICE, $2=PRODUCT_OUT, $3=LINEAGE_VERSION.zip
output=$2/$1.json

#cleanup old file
if [ -f $output ]; then
	rm $output
fi

# properties
buildprop=$2/system/build.prop
linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
datetime=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
filename=$3
md5=`md5sum "$2/$3" | cut -d' ' -f1`
romtype="Official"
size=`stat -c "%s" "$2/$3"`
url="https://sourceforge.net/projects/lineage-x/files/$1/$3/download?"
version=${filename::-4}

echo '{
"response": [
	{
		"datetime": '$datetime',
		"filename": "'$filename'",
		"id": "'$md5'",
		"romtype": "'$romtype'",
		"size": '$size',
		"url": "'$url'",
		"version": "'$version'",
	}
]
}'>>$output

echo "JSON file data for OTA support:"
cat $output
echo ""
