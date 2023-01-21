#!/bin/sh -l

GITHASH_STR="<b>Commits used to build this release:</b><br>"

append_githash_info () {
    GITHASH=$(git rev-parse HEAD)
    GITHASH_SHORT=$(echo "$GITHASH" | cut -c 1-7)
    GITNAME=$(basename "$(git rev-parse --show-toplevel)")
    [ -z "$1" ] || GITNAME=$1
    GITURL=$(git config --get remote.origin.url)
    GITHASH_STR="$GITHASH_STR $GITNAME: [$GITHASH_SHORT]($GITURL/commit/$GITHASH)<br>"
}

git clone --no-checkout https://github.com/qmk/qmk_firmware --depth 1 

cd qmk_firmware || exit 1
git config core.sparsecheckout true
echo '/*\n!/keyboards\n/keyboards/nullbitsco/*\n' > .git/info/sparse-checkout
git checkout --

append_githash_info

# Add tidbit extras repo
cd keyboards/nullbitsco || exit 1
git submodule add https://github.com/nullbitsco/tidbit tidbit_extras
ln -s "$(realpath .)/tidbit_extras/keymaps/*" tidbit/keymaps

cd tidbit_extras || exit 1
append_githash_info
cd ../

# Add snap repo
git submodule add https://github.com/nullbitsco/snap snap
cd snap || exit 1
append_githash_info
cd ../

qmk setup -y

# Compile for AVR
for t in nibble tidbit scramble snap;
    do echo "Building QMK for $t";
    qmk compile -j 2 -kb nullbitsco/$t -km all
done

# Checkout nullbits rp2040 repo
git config advice.detachedHead false
git remote add nullbits https://github.com/jaygreco/qmk_firmware.git
git fetch nullbits --depth=1 2> /dev/null
git checkout nullbits/rp2040_clean

append_githash_info "qmk_firmware rp2040"

# Update submodules after repo switch, but before checking out rp2040 SNAP
cd ../../
make git-submodule

# Checkout nullbits rp2040 snap repo
cd keyboards/nullbitsco/snap || exit 1
git checkout rp2040_clean
append_githash_info "snap rp2040"
cd ../../../

# Compile for RP2040
for t in nibble/rp2040 tidbit/rp2040 scramble/v2 snap/rp2040;
    do echo "Building QMK for $t";
    qmk compile -j 2 -kb nullbitsco/$t -km all
done

echo "::set-output name=commits::$GITHASH_STR"

ls *.hex
ls *.uf2
