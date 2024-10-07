#!/bin/zsh

# Check if GStreamer is installed and exit if not
command -v gst-launch-1.0 &> /dev/null || return

# 1 - ERROR, 2 - WARNING, 3 - FIXME, 4 - INFO,
# 5 - DEBUG, 6 - LOG, 7 - TRACE, 9 - MEMDUMP
export GST_DEBUG=2

if [[ -d "/Library/Frameworks/GStreamer.framework/Versions/Current" ]]; then
    export GST_PLUGIN_PATH="/Library/Frameworks/GStreamer.framework/Versions/Current/lib/gstreamer-1.0"
    export GST_PLUGIN_SCANNER="/Library/Frameworks/GStreamer.framework/Versions/Current/libexec/gstreamer-1.0/gst-plugin-scanner"
    export GST_PLUGIN_SYSTEM_PATH="/Library/Frameworks/GStreamer.framework/Versions/Current/lib/gstreamer-1.0"
    export PATH="/Library/Frameworks/GStreamer.framework/Versions/Current/bin:$PATH"
    # GStreamer environment setup
    GST_ENV_PATH=$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/share/gstreamer/gst-env" 2>/dev/null)
    [[ -f "$GST_ENV_PATH" ]] && . "$GST_ENV_PATH"
    export GST_PLUGIN_SYSTEM_PATH_1_0=$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/Libraries/gstreamer-1.0" 2>/dev/null)
    export GST_PLUGIN_PATH_1_0=$HOME/.local/lib/gstreamer-1.0
    export GST_PLUGIN_SCANNER_1_0=$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/libexec/gstreamer-1.0/gst-plugin-scanner" 2>/dev/null)
    GST_PATH="$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/bin" 2>/dev/null):$(realpath "/Library/Frameworks/GStreamer.framework/Versions/Current/libexec/gstreamer-1.0" 2>/dev/null)"
    export PATH="$GST_PATH:$PATH"
    unset GST_PATH
    unset GST_ENV_PATH
fi

GST_PATH_PREFIX=$(brew --prefix gstreamer 2>/dev/null)
if [[ -n "$GST_PATH_PREFIX" ]]; then
    export PATH="$GST_PATH_PREFIX/bin:$PATH"
    export GST_PLUGIN_SYSTEM_PATH="$GST_PATH_PREFIX/lib/gstreamer-1.0"
    export GST_PLUGIN_SYSTEM_PATH_1_0="$GST_PLUGIN_SYSTEM_PATH"
    export GST_PLUGIN_PATH="$GST_PATH_PREFIX/lib/gstreamer-1.0"
    export GST_PLUGIN_PATH_1_0="$GST_PLUGIN_PATH"
    export PKG_CONFIG_PATH="$GST_PATH_PREFIX/lib/pkgconfig"
fi
unset GST_PATH_PREFIX
