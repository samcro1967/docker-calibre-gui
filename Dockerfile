# This is a dummy Dockerfile.
# See https://github.com/jlesage/docker-baseimage-gui to get the content of the
# Dockerfile used to generate this image.
# Edit by jiris for calibre

# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-18.04

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
RUN add-pkg python
RUN add-pkg xdg-utils
RUN add-pkg xz-utils
RUN add-pkg wget
RUN add-pkg dbus

RUN \

# Problem with uuid, solved by this
dbus-uuidgen > /var/lib/dbus/machine-id && \

# Problem with certificates, solved by this (otherwise calibre will not install)
apt-get update && \
apt-get install -y ca-certificates && \
cd /etc/ssl/certs && \
wget --no-check-certificate http://curl.haxx.se/ca/cacert.pem && \
update-ca-certificates -f && \

#########################################
##          GUI APP INSTALL            ##
#########################################
# Download and install calibre
wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin

# Copy the start script.
COPY startapp.sh /startapp.sh

# Set the name of the application.
ENV APP_NAME="Calibre"

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/kovidgoyal/calibre/raw/master/icons/calibre.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Port 8081 for Content server 
VOLUME ["/config"]
VOLUME ["/storage"]
EXPOSE 8081
