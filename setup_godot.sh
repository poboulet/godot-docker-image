#!/bin/bash

# Arguments passed to the script
GODOT_VERSION=$1
MONO=$2

# Set URLs and directories based on whether Mono is enabled
if [ "$MONO" = "true" ]; then
    DOWNLOAD_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64.zip"
    TEMPLATE_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz"
    INSTALL_DIR="/usr/local/bin/Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64"
    TEMPLATE_DIR="/godot/export_templates/${GODOT_VERSION}.stable.mono/"
    SYMLINK_TEMPLATE_DIR="/root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/"
    EXECUTABLE_NAME="Godot_v${GODOT_VERSION}-stable_mono_linux.x86_64"
else
    DOWNLOAD_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip"
    TEMPLATE_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz"
    INSTALL_DIR="/usr/local/bin"
    TEMPLATE_DIR="/godot/export_templates/${GODOT_VERSION}.stable/"
    SYMLINK_TEMPLATE_DIR="/root/.local/share/godot/export_templates/${GODOT_VERSION}.stable/"
    EXECUTABLE_NAME="Godot_v${GODOT_VERSION}-stable_linux.x86_64"
fi

FULL_PATH="${INSTALL_DIR}/${EXECUTABLE_NAME}"

# Download and set up Godot
echo "Downloading Godot from ${DOWNLOAD_URL}"
wget -q $DOWNLOAD_URL -O godot.zip
unzip godot.zip -d /usr/local/bin/
if [ $? -ne 0 ]; then
    echo "Error: unzip failed while extracting Godot."
    exit 1
fi
chmod +x "${FULL_PATH}"

# Create wrapper script for xvfb-run
echo "#!/bin/bash" > /usr/local/bin/godot
# Dummy audio driver to prevent runtime errors
echo "xvfb-run ${FULL_PATH} --audio-driver Dummy \"\$@\"" >> /usr/local/bin/godot
chmod +x /usr/local/bin/godot

# Download and set up export templates
wget -q $TEMPLATE_URL -O templates.tpz
mkdir -p $TEMPLATE_DIR
unzip -o -j templates.tpz -d $TEMPLATE_DIR
if [ $? -ne 0 ]; then
    echo "Error: unzip failed while extracting export templates."
    exit 1
fi

# Create symlink for export templates
mkdir -p $SYMLINK_TEMPLATE_DIR
echo $SYMLINK_TEMPLATE_DIR
cd $SYMLINK_TEMPLATE_DIR
pwd
ln -sfn $TEMPLATE_DIR $SYMLINK_TEMPLATE_DIR

