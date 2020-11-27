set -e
set -x

make ARCH=mips CROSS_COMPILE=mips64-linux-gnu- -j$(( $(nproc) * 2 )) vmlinux.bin dtbs
cat arch/mips/boot/vmlinux.bin arch/mips/boot/dts/ingenic/mipsbook_400.dtb |gzip >vmlinux.bin.gz

/usr/bin/mkimage \
       -A mips \
       -O linux \
       -C gzip \
       -T kernel \
       -a $(readelf -a vmlinux |awk '/^ *LOAD *0x/ {print $3}') \
       -e $(readelf -a vmlinux |awk '/Entry point address:/ {print $NF}') \
       -d vmlinux.bin.gz \
       uImage
