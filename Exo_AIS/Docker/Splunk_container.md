```sh
docker run -d \
  --name splunk \
  -p 8000:8000 \
  -p 8089:8089 \
  -e SPLUNK_START_ARGS="--accept-license" \
  -e SPLUNK_GENERAL_TERMS="--accept-sgt-current-at-splunk-com" \
  -e SPLUNK_PASSWORD="MOTDEPASSE" \
  splunk/splunk:latest start
  ```