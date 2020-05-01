#!/bin/bash
assets_dir="/assets"
repo_dir="/repo"
selector="[public]_"

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
}

select_files(){
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
  cd ..
}

sync_repo(){
  echo Sync repo
  cd $repo_dir
  git config user.name w3fbot
  git add -A
  git commit -m "Commit at $date"
  git status
  git push https://${GITHUB_BOT_TOKEN}@github.com/web3-assets.git
}

init_directory
echo Sync with drive
rclone sync --progress drive: $assets_dir
select_files
sync_repo
