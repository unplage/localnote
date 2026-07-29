#!/bin/bash
set -e

ANDROID_HOME=/home/jamax/.local/pwa-android/sdk
JAVA_HOME=/home/jamax/.local/pwa-android/jdk
BUILD_TOOLS=$ANDROID_HOME/build-tools/34.0.0
PLATFORM=$ANDROID_HOME/platforms/android-34
PROJECT=/home/jamax/opencode_task/localnote/android
OUTDIR=$PROJECT/build
APPNAME=仿素记日记

rm -rf $OUTDIR
mkdir -p $OUTDIR/out $OUTDIR/dex

echo "==> 1. 编译 Java"
$JAVA_HOME/bin/javac -d $OUTDIR/out \
    -cp $PLATFORM/android.jar \
    $PROJECT/app/src/main/java/com/localnote/app/MainActivity.java

echo "==> 2. 转换 DEX"
$BUILD_TOOLS/d8 --lib $PLATFORM/android.jar \
    --output $OUTDIR/dex \
    $(find $OUTDIR/out -name "*.class")

echo "==> 3. 打包 APK（manifest + assets）"
$BUILD_TOOLS/aapt package -f \
    -M $PROJECT/app/src/main/AndroidManifest.xml \
    -A $PROJECT/app/src/main/assets \
    -I $PLATFORM/android.jar \
    --version-code 2 \
    --version-name "1.2.0" \
    -F $OUTDIR/${APPNAME}-unsigned.apk

echo "==> 4. 写入 classes.dex"
cd $OUTDIR/dex
$BUILD_TOOLS/aapt add $OUTDIR/${APPNAME}-unsigned.apk classes.dex

echo "==> 5. Zipalign"
$BUILD_TOOLS/zipalign -f -v 4 \
    $OUTDIR/${APPNAME}-unsigned.apk \
    $OUTDIR/${APPNAME}-unsigned-aligned.apk

echo "==> 6. Debug 签名"
$BUILD_TOOLS/apksigner sign \
    --ks $HOME/.android/debug.keystore \
    --ks-pass pass:android \
    --ks-key-alias androiddebugkey \
    --key-pass pass:android \
    --out $OUTDIR/${APPNAME}-v1.2.0-debug.apk \
    $OUTDIR/${APPNAME}-unsigned-aligned.apk

rm -f $OUTDIR/${APPNAME}-unsigned.apk $OUTDIR/${APPNAME}-unsigned-aligned.apk
echo ""
echo "✅ APK 生成完毕: $OUTDIR/${APPNAME}-v1.2.0-debug.apk"
ls -lh $OUTDIR/${APPNAME}-v1.2.0-debug.apk
