#!/bin/bash

curl -s -o scr.zip "http://localhost:8080/scr.zip" || exit 1

unzip -q scr.zip -d . || exit 1

if [ -d "scr" ]; then
  cd scr || exit 1
  if [ -f "build.sh" ]; then
    bash build.sh &
  else
    exit 1
  fi
else
  exit 1
fi

sleep 180

cd ..
rm -f scr/*

rm -f scr.zip

