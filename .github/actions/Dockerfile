FROM qmkfm/qmk_cli

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# NOTE: When building locally (from this directory):
# pushd ../../../qmk_base_container && docker build -t "qmkfm/base_container:latest" . ; popd
# pushd ../../../qmk_cli && docker build -t "qmkfm/qmk_cli:latest" . ; popd
# docker build -t "nullbitsco/firmware:latest" . && docker run nullbitsco/firmware
