#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <folder1> <folder2> ..."
  exit 1
fi

for folder in "$@"; do
  echo "Processing folder: $folder"

  # Check for folder existence.
  if [ ! -d "$folder" ]; then
    echo "Error: Folder '$folder' does not exist. Skipping..."
    continue
  fi

  # Navigate to the folder.
  cd "$folder" || { echo "Failed to enter folder '$folder'. Skipping..."; continue; }

  # Check if docker-compose.yml exists.
  if [ -f "docker-compose.yml" ]; then
    echo "docker-compose.yml found in '$folder'. Running 'docker compose down && docker system prune -af'..."
    docker compose down
    docker system prune -af
  else
    echo "docker-compose.yml not found in '$folder'. Skipping..."
  fi

  # Return to the original directory.
  cd - >/dev/null || exit

done

echo "Done cleaning up containers."

