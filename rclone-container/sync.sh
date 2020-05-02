#!/bin/bash
assets_dir="${ASSETS_DIRECTORY:-assets}"
repo_dir="${REPO_DIRECTORY:-repo}"
selector="${PUBLISH_SELECTOR:-Publish}"

mkdir -p $repo_dir
mkdir -p $assets_dir

init_directory(){
  if [ -d "$repo_dir/.git" ]; then
    echo .git dir, procceding with pull
    cd $repo_dir
    git pull https://github.com/w3f/web3-assets.git
    cd ..
  else
    echo NOT a .git dir, procceding with clone
    git clone https://github.com/w3f/web3-assets.git $repo_dir
  fi

  echo Sync with drive
  rclone sync --progress drive: $assets_dir  
}

sync_files(){
  echo Selecting files
  cd $assets_dir
  path_list=($(find . -type f | grep "$selector" ))
  for path in "${path_list[@]}"
  do
    src="${path:2}"
    trg="../$repo_dir/$(dirname "${path:2}")/"
    mkdir -p $trg
    cp $src  "../$repo_dir/${path:2}" || true
  done

  echo Checking for deleted files
  cd ../$repo_dir
  path_list=($(find . -type f | grep -v ".git" ))
  for path in "${path_list[@]}"
  do
    test_path="../$assets_dir/${path:2}"
    if [ -f "$test_path" ]; then
        echo "$test_path exist"
    else
        echo "$test_path does not exist in assets, removing: $path"
        rm $path || true
    fi
  done

  echo Removing empty directories
  find . -type d -empty -delete || true
  cd ..
}

sync_repo(){
  echo Sync repo
  cd $repo_dir
  git config user.name w3fbot
  git add -A
  git commit -m "Auto sync"
  git status
  git push -q https://${GITHUB_BOT_TOKEN}@github.com/web3-assets.git
}

init_directory
sync_files
sync_repo
