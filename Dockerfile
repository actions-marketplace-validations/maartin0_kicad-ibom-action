FROM kicad/kicad:9.0

USER root
# The KiCad image by default sets up library tables in /home/kicad
# but we have to use the root user due to limitations set by GitHub actions
RUN cp -r /home/kicad/.config/kicad "$HOME/.config/"

RUN apt-get update && \
    apt-get install -y python3-pip && \
    python3 -m pip install InteractiveHtmlBom --break-system-packages

COPY gen-ibom.sh /gen-ibom.sh
ENTRYPOINT [ "/gen-ibom.sh" ]
