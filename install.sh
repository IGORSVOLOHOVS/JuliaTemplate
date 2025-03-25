#!/bin/bash

# Get current date and time
datestamp=$(date +%Y%m%d-%H%M%S)

# Set paths
repoURL="https://github.com/IGORSVOLOHOVS/TaskManager.git"
cloneDir=$(mktemp -d -t "${datestamp}XXX")  # Creates a temp directory.
targetDir="/home/igors/Projects/Task-${datestamp}"

# Create the target directory
mkdir -p "$targetDir" || { echo "Failed to create target directory"; exit 1; }

# Clone the repository (sparse checkout)
git clone -n --depth=1 --filter=tree:0 "$repoURL" "$cloneDir" || { echo "Git clone failed"; exit 1; }

# Change directory and set up sparse checkout
cd "$cloneDir" || { echo "Failed to change directory to cloneDir"; exit 1; }
git sparse-checkout set --no-cone TaskTools || { echo "Sparse checkout failed"; exit 1; }
git checkout || { echo "Git checkout failed"; exit 1; }

# Copy *contents* of TaskTools to the target directory.  THIS IS THE KEY CHANGE.
cp -r "$cloneDir/TaskTools/." "$targetDir" || { echo "Copy failed"; exit 1; }

# Initialize a new Git repository in the target directory
cd "$targetDir" || { echo "Failed to change directory to targetDir"; exit 1; }
git init || { echo "Git init failed"; exit 1; }

# Open the target directory in VS Code (if installed)
if command -v code &> /dev/null; then
  code "$targetDir"
else
  echo "VS Code (code) not found.  Skipping opening the directory."
fi

# Remove the temporary clone directory
rm -rf "$cloneDir" || { echo "Warning: Failed to remove temporary directory: $cloneDir"; }

echo "Script completed successfully.  Project directory: $targetDir"

exit 0