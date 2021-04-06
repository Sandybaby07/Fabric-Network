checkChannelFolder() {
  if [ ! -d "channel-artifacts/$1" ]; then
    mkdir channel-artifacts/$1
  fi
}