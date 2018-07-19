FROM alpine:latest

MAINTAINER Gwenn Etourneau <gwenn.etourneau@gmail.com>

RUN apk upgrade
RUN apk add --update \
    bash \
    git \
    tar \
    curl \
    openssh-client \
    openssh \
    zip \
    rsync \
    python py2-pip  \
    jq \
    wget && \
    pip install sshuttle && \
    apk del py2-pip && \
    curl -s https://api.github.com/repos/pivotal-cf/om/releases/latest \
    | jq -r '.assets[] | select(.name=="om-linux") | .browser_download_url' \
    | wget -qi - -O /bin/om \
    && chmod +x /bin/om \
    && ln -s /bin/om /bin/om-linux \
    && rm /var/cache/apk/*


RUN version_number=$(curl 'https://github.com/cloudfoundry/bosh-cli/releases/latest' 2>&1 | egrep -o '([0-9]+\.[0-9]+\.[0-9]+)') && \
    curl -s "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${version_number}-linux-amd64" -o /bin/bosh && \
    chmod +x /bin/bosh
