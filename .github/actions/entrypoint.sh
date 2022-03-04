#!/bin/sh -l

GITHASH_STR="<b>Commits used to build this release:</b><br>"

append_githash_info () {
    GITHASH=$(git rev-parse HEAD)
    GITHASH_SHORT=$(echo "$GITHASH" | cut -c 1-7)
    GITNAME=$(basename `git rev-parse --show-toplevel`)
    GITURL=$(git config --get remote.origin.url)
    GITHASH_STR="$GITHASH_STR $GITNAME: [$GITHASH_SHORT]($GITURL/commit/$GITHASH)<br>"
}

git clone --no-checkout https://github.com/qmk/qmk_firmware --depth 1 

cd qmk_firmware

git config core.sparsecheckout true
echo '/*\n!/keyboards\n/keyboards/nullbitsco/*\n' > .git/info/sparse-checkout
git checkout --

append_githash_info

cd keyboards/nullbitsco
git submodule add https://github.com/nullbitsco/tidbit tidbit
git submodule add https://github.com/nullbitsco/snap snap

cd snap
append_githash_info
cd ../

cd tidbit
append_githash_info
cd ../

echo "::set-output name=commits::$GITHASH_STR"

cd ../../

qmk setup -y

make all