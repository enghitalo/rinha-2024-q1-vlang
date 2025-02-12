FROM debian

RUN apt-get -qq update
RUN apt-get -qy install --no-install-recommends build-essential git clang tcc libpq-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/vlang:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV GIT_SSL_NO_VERIFY=1

WORKDIR /opt/vlang

RUN git clone --depth 1 https://github.com/vlang/v /opt/vlang

# choose v version `tags/weekly.2024.06`
RUN git fetch --all --tags && git checkout tags/weekly.2024.06 && make && v -version

RUN ln -s /opt/vlang/v /usr/bin/v

WORKDIR /app

COPY ./src /app/src

#Create a build directory
RUN mkdir /app/bin

RUN v /app/src -d debug -prod -o /app/bin/app

ENTRYPOINT ["/app/bin/app"]
