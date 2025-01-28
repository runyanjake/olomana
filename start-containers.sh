#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <folder1> <folder2> ..."
  exit 1
fi

for folder in "$@"; do
  echo "Processing folder: $folder"

  # Check for folder existance.
  if [ ! -d "$folder" ]; then
    echo "Error: Folder '$folder' does not exist. Skipping..."
    continue
  fi

  # Navigate to the folder.
  cd "$folder" || {
    echo "Failed to enter folder '$folder'. Skipping..."
    continue
  }

  # Take actions based on existance of Dockerfile/docker-compose.yml.
  if [ -f "Dockerfile" ]; then
    echo "Dockerfile found in '$folder'. Running 'docker compose build'..."
    docker compose build
  fi
  if [ -f "docker-compose.yml" ]; then
    echo "Dockerfile not found but docker-compose.yml exists in '$folder'. Running 'docker compose up -d'..."
    docker compose up -d
  fi

  # Return to the original directory.
  cd - >/dev/null || exit

done

echo "Done starting containers."
