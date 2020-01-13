#!/usr/bin/env bash
cd "$(dirname "$0")"
PLUGIN_DIR=~/.terraform.d/plugins/linux_amd64

GANDI_PROVIDER_NAME="terraform-provider-gandi"
GANDI_PROVIDER_VERSION="master"
GANDI_PROVIDER_ARCHIVE="${GANDI_PROVIDER_NAME}-${GANDI_PROVIDER_VERSION}.zip"
GANDI_PROVIDER_URL="https://github.com/tiramiseb/terraform-provider-gandi/archive/${GANDI_PROVIDER_VERSION}.zip"
GANDI_PROVIDER_PATH="${PLUGIN_DIR}/${ARCH}/${GANDI_PROVIDER_NAME}_v${GANDI_PROVIDER_VERSION}"

if [[ -z $(which go) ]]; then
    echo "No go compiler in PATH, consider doing:\n\tsudo snap install go --classic"
    exit 1;
fi
if [[ -z $(which unzip) ]]; then
    echo "No unzip in PATH, consider doing:\n\tsudo apt install unzip"
    exit 1;
fi

mkdir -p ${PLUGIN_DIR};
wget -nc ${GANDI_PROVIDER_URL} -O ./${GANDI_PROVIDER_ARCHIVE};
echo "Unzipping..."; 
unzip -qq -o ./${GANDI_PROVIDER_ARCHIVE} -d ./;
echo "Unzip complete!"; 
cd ./${GANDI_PROVIDER_NAME}-${GANDI_PROVIDER_VERSION};
echo "Building....";
go build -o terraform-provider-gandi;
echo "Built!";
cd -;
mkdir -p ${PLUGIN_DIR}/${ARCH}; 
echo "Copying ./${GANDI_PROVIDER_NAME}-${GANDI_PROVIDER_VERSION}/terraform-provider-gandi to ${PLUGIN_DIR}/${ARCH}/${GANDI_PROVIDER_NAME}_v${GANDI_PROVIDER_VERSION}";
cp -v ./${GANDI_PROVIDER_NAME}-${GANDI_PROVIDER_VERSION}/terraform-provider-gandi \
    ${PLUGIN_DIR}/${ARCH}/${GANDI_PROVIDER_NAME}_v${GANDI_PROVIDER_VERSION}; 
echo "Doing a stupid hack"; 
mv -v ${PLUGIN_DIR}/${ARCH}/${GANDI_PROVIDER_NAME}_v${GANDI_PROVIDER_VERSION}  \
      ${PLUGIN_DIR}/${ARCH}/${GANDI_PROVIDER_NAME}_v1.1.1;

rm -Rf ./${GANDI_PROVIDER_ARCHIVE}  ./${GANDI_PROVIDER_NAME}-${GANDI_PROVIDER_VERSION}