#!/bin/zsh

# Check if GStreamer is installed and exit if not
command -v gst-launch-1.0 &> /dev/null || return

# GStreamer environment setup
GST_ENV_PATH=$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/share/gstreamer/gst-env" 2>/dev/null)
[[ -f "$GST_ENV_PATH" ]] && . "$GST_ENV_PATH"

# 1 - ERROR, 2 - WARNING, 3 - FIXME, 4 - INFO,
# 5 - DEBUG, 6 - LOG, 7 - TRACE, 9 - MEMDUMP
export GST_DEBUG=2

export GST_PLUGIN_SYSTEM_PATH_1_0=$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/Libraries/gstreamer-1.0" 2>/dev/null)
export GST_PLUGIN_PATH_1_0=$HOME/.local/lib/gstreamer-1.0
export GST_PLUGIN_SCANNER_1_0=$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/libexec/gstreamer-1.0/gst-plugin-scanner" 2>/dev/null)

GST_PATH="$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/bin" 2>/dev/null):$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/libexec/gstreamer-1.0" 2>/dev/null)"
export PATH="$GST_PATH:$PATH"

unset GST_PATH
unset GST_ENV_PATH
