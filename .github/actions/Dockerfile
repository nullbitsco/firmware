FROM qmkfm/qmk_cli

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# NOTE: When building locally (from this directory):
# docker pull docker.io/qmkfm/qmk_cli
# docker build -t "nullbitsco/firmware:latest" . && docker run nullbitsco/firmware
