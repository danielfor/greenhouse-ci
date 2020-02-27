$ErrorActionPreference = "Stop";
trap { Exit 1 }

Import-Module ./ci/tasks/common/setup-windows-container.psm1
Set-TmpDir

pushd stembuild-untested-windows
    Move-Item stembuild* stembuild.exe
popd

Move-Item stembuild-untested-windows/stembuild.exe .

ICACLS stembuild.exe /grant:r "users:(RX)" /C

$version="$(cat .\build-number\number)"
$patch,$build=$version.split('.')[2,3]
$patch_version="$patch.$build"

.\stembuild.exe package -vcenter-url $env:VCENTER_BASE_URL -vcenter-username $env:VCENTER_USERNAME -vcenter-password $env:VCENTER_PASSWORD -vm-inventory-path $env:VCENTER_VM_FOLDER/$env:STEMBUILD_BASE_VM_NAME -patch-version $patch_version

Move-Item *.tgz stembuild-built-stemcell