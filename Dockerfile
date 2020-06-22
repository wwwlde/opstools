FROM alpine:latest

MAINTAINER Denis Lemeshko <lde@linuxhelp.com.ua>

RUN echo "==> Installing sudo to emulate normal OS behavior..."  && \
    apk --no-cache --update add sudo                              && \
    echo "==> Adding Python runtime..."  && \
    apk --no-cache --update add python3 openssl ca-certificates sshpass openssh-client bash && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    apk --no-cache --update add curl jq git git-crypt && \
    apk --no-cache --update add --virtual build-dependencies \
                python3-dev libffi-dev openssl-dev build-base wget && \
    pip3 install --no-cache-dir --no-cache --upgrade pip && \
    echo "==> Installing Ansible..."  && \
    pip3 install --no-cache --no-cache-dir ansible && \
    echo "==> Install promtool..."  && \
    wget https://github.com/prometheus/prometheus/releases/download/v2.17.2/prometheus-2.17.2.linux-amd64.tar.gz && \
    tar pzxf prometheus-2.17.2.linux-amd64.tar.gz && \
    mv -v prometheus-2.17.2.linux-amd64/promtool /usr/local/bin/ && \
    rm -rf prometheus-2.17.2.linux-amd64 prometheus-2.17.2.linux-amd64.tar.gz && \
    echo "==> Removing package list..."  && \
    apk --no-cache del wget build-dependencies && \
    rm -f ~/.wget-hsts && \
    rm -rf /var/cache/apk/*               && \
    echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo -e "[local]\nlocalhost ansible_connection=local" > \
        /etc/ansible/hosts

CMD [ "ansible", "--version" ]
