FROM debian:12
RUN apt-get update && apt-get install -y apt-rdepends apt-utils dpkg-dev ca-certificates \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /repo
COPY add-with-deps.sh /repo/add-with-deps.sh
ENTRYPOINT ["/repo/add-with-deps.sh"]
