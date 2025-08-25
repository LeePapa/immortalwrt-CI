echo "==== SmartDns 处理 ===="
WORKINGDIR="`pwd`/feeds/packages/net/smartdns"
echo "==== ls路径 ===="
ls $WORKINGDIR
echo "==== ls路径结束 ===="
echo "==== Cat Makefile ===="
cat $WORKINGDIR/Makefile
echo "==== Cat Makefile End===="
echo "==== Tree ===="
ls ../
echo "==== Tree End===="
mkdir -p $WORKINGDIR
rm -fr $WORKINGDIR/*
wget https://github.com/xianren78/openwrt-smartdns/archive/master.zip -O $WORKINGDIR/master.zip
unzip $WORKINGDIR/master.zip -d $WORKINGDIR
mv $WORKINGDIR/openwrt-smartdns-master/* $WORKINGDIR/
rmdir $WORKINGDIR/openwrt-smartdns-master

# 自动计算源码包哈希
HASH=$(sha256sum "$WORKINGDIR/master.zip" | awk '{print $1}')

# 修改 Makefile 里的 PKG_HASH
MAKEFILE="$WORKINGDIR/Makefile"
if grep -q "^PKG_HASH:=" "$MAKEFILE"; then
    sed -i "s/^PKG_HASH:=.*/PKG_HASH:=$HASH/" "$MAKEFILE"
else
    # 在 PKG_SOURCE_URL 或 PKG_VERSION 之后添加 PKG_HASH
    sed -i "/^PKG_SOURCE_URL\|^PKG_VERSION/a PKG_HASH:=$HASH" "$MAKEFILE"
fi
rm $WORKINGDIR/master.zip
echo "PKG_HASH 已自动更新为：$HASH"
