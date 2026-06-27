#!/usr/bin/env bash
# Start a dedicated Xorg server bound to the NVIDIA GPU so AI2-THOR can render
# with hardware GL (libGLX_nvidia) instead of slow Mesa software GL (llvmpipe).
#
# Software GL grinds at ~820% CPU on real ALFRED scenes and the THOR socket dies,
# which is why evaluation hangs on the first task. GPU rendering fixes this.
#
# Usage (needs root for Xorg):
#   sudo bash scripts/start_xorg_gpu.sh           # starts Xorg on :1
#   sudo bash scripts/start_xorg_gpu.sh 2         # starts Xorg on :2
#
# Stop it with:  sudo pkill -f "Xorg :1"

set -e

DISPLAY_NUM="${1:-1}"
# RTX 3090 BusID from nvidia-smi (00000000:01:00.0) -> Xorg format PCI:1:0:0
BUSID="PCI:1:0:0"
CONF="/tmp/xorg-gpu-${DISPLAY_NUM}.conf"

cat > "$CONF" <<EOF
Section "ServerLayout"
    Identifier     "Layout0"
    Screen      0  "Screen0"
EndSection

Section "Files"
    # nvidia_drv.so lives in a split path on this box; Xorg only searches the
    # default dir by default, so add the nvidia module path explicitly.
    ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection

Section "Monitor"
    Identifier     "Monitor0"
    HorizSync       28.0 - 33.0
    VertRefresh     43.0 - 72.0
    Option         "DPMS"
EndSection

Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "${BUSID}"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "AllowEmptyInitialConfiguration" "True"
    SubSection     "Display"
        Depth       24
        Virtual     1024 768
    EndSubSection
EndSection
EOF

echo "Wrote $CONF (BusID=$BUSID)"
echo "Starting Xorg on :${DISPLAY_NUM} ..."
nohup Xorg ":${DISPLAY_NUM}" -noreset +extension GLX +extension RANDR +extension RENDER \
    -config "$CONF" -logfile "/tmp/xorg-gpu-${DISPLAY_NUM}.log" >/dev/null 2>&1 &
sleep 3

if [ -e "/tmp/.X11-unix/X${DISPLAY_NUM}" ]; then
    echo "OK: Xorg is up on DISPLAY=:${DISPLAY_NUM}"
    echo "Now run evaluation with:"
    echo "    DISPLAY=:${DISPLAY_NUM} python scripts/evaluate.py alfred.x_display=${DISPLAY_NUM}"
else
    echo "FAILED: see /tmp/xorg-gpu-${DISPLAY_NUM}.log"
    exit 1
fi