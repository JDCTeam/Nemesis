#!/bin/bash
# Usage: ./multirom.sh [optional variable]
DEST_DIR="/home/antaresone/android/opt-5.1" # to your Android source's root
TARGET="cm_jflte-userdebug"

BASE="$DEST_DIR"/out/target/product/jflte
IMG="$BASE"/recovery.img
RECOVERY_SUBVER="00" # change only if > 1 build/same day
DEST_NAME="TWRP_multirom_jflte_$(date +%Y%m%d)-$RECOVERY_SUBVER.img"

noclean=false
recoveryonly=false
multiromonly=false

for a in $@; do
    case $a in
        -h|--help)
            echo "$0 [noclean] [recovery] [multirom]"
            exit 0
            ;;
        noclean)
            noclean=true
            ;;
        recovery)
            recoveryonly=true
            ;;
        multirom)
            multiromonly=true
            ;;
    esac
done

. build/envsetup.sh

lunch $TARGET

if ! $noclean; then
    rm -r "$OUT"
fi

if $recoveryonly; then
    make -j5 recoveryimage
elif $multiromonly; then
    make -j5 multirom_zip
else
    make -j5 recoveryimage multirom_zip
fi

if ! $multiromonly; then
    bbootimg -u $IMG -c "name = mrom$(date +%Y%m%d)-$RECOVERY_SUBVER"
	cp $IMG $BASE$DEST_NAME
fi
