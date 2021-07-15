#!/bin/sh -l

git clone --no-checkout https://github.com/qmk/qmk_firmware.git --depth 1 

cd qmk_firmware

git config core.sparsecheckout true
echo '/*\n!/keyboards\n/keyboards/nullbitsco/*\n' > .git/info/sparse-checkout
git checkout --

cd keyboards/nullbitsco
git submodule add https://github.com/nullbitsco/tidbit tidbit

cd ../../

qmk setup -y

make all