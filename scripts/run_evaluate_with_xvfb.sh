#!/usr/bin/env bash
# Run ALFRED evaluation with a virtual display (GLX) to avoid:
#   X Error: BadValue ... Major opcode 152 (GLX) Minor opcode 3 (X_GLXCreateContext)
# Use on headless servers when no physical display is available.

set -e
cd "$(dirname "$0")/.."

# Force Mesa software GL so GLX context works on Xvfb (Unity/THOR often fails with default)
export MESA_GL_VERSION_OVERRIDE=3.3
export __GLX_VENDOR_LIBRARY_NAME=mesa

# Clean up zombie THOR/Xvfb from prior failed runs (they hold CPU/GPU/sockets and
# make the next THOR start hang on its socket handshake)
pkill -9 -f "thor-201909" 2>/dev/null || true
pkill -9 -f "Xvfb" 2>/dev/null || true
sleep 1

# Find a free display number and start Xvfb
DISPLAY_NUM="${DISPLAY_NUM:-99}"
for d in $(seq $DISPLAY_NUM 120); do
  if [ ! -f "/tmp/.X${d}-lock" ]; then
    DISPLAY_NUM=$d
    break
  fi
done

Xvfb :${DISPLAY_NUM} +extension GLX +iglx +extension RENDER -screen 0 1024x768x24 &
XVFB_PID=$!
sleep 2
trap "kill $XVFB_PID 2>/dev/null" EXIT

export DISPLAY=:${DISPLAY_NUM}
exec python scripts/evaluate.py alfred.x_display="$DISPLAY_NUM" "$@"
