#!/bin/bash
mkdir -p /root/.config/rclone/
echo [$DRIVE_NAME] > /root/.config/rclone/rclone.conf
echo type = $DRIVE_NAME >> /root/.config/rclone/rclone.conf
echo scope = $DRIVE_NAME.$DRIVE_SCOPE >> /root/.config/rclone/rclone.conf
echo root_folder_id = $ROOT_FOLDER_ID >> /root/.config/rclone/rclone.conf
echo token = $DRIVE_TOKEN >> /root/.config/rclone/rclone.conf

assets_dir="${ASSETS_DIRECTORY:-assets}"
repo_dir="${REPO_DIRECTORY:-repo}"
selector="${PUBLISH_SELECTOR:-Public}"

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
  OIFS="$IFS"
  IFS=$'\n'
  for path in $(find $assets_dir -type f | grep "$selector" )
  do
  printf "File to publish: %s\n" "$path"
  trg="$repo_dir/$(dirname "${path}")/"
  mkdir -p "$trg"
  cp "$path" "$trg"
  done


  echo Checking for deleted files
  for path in $(find $repo_dir -type f | grep -v ".git" )
  do
    assetfile="${path##repo}"
    echo Cheking for $path at: $assetfile
    if [ -f $assetfile ]
    then
      echo $assetfile exists.
    else
      echo $assetfile removed, removing from repo $path
      #rm -f $path
    fi
  done

  echo Removing empty directories
  find $repo_dir -type d -empty -delete || true
}

sync_repo(){
  echo Sync repo
  cd $repo_dir
  git config --global user.name "w3fbot"
  git config --global user.email "devops@web3.foundation"
  git add -A
  git commit -m "Auto sync"
  git status
  if [ -z "$CI" ]; then
      git push -q https://${GITHUB_BOT_TOKEN}@github.com/w3f/web3-assets.git
  fi
}

init_directory
sync_files
sync_repo
