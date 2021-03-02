FROM dockerkun/ruby_docker_jemalloc:2.7.2

RUN apt-get update \
  && apt-get install -y build-essential libmagickwand-dev default-mysql-client vim jpegoptim optipng cron curl libmariadb-dev libcurl4-openssl-dev

COPY ./mysql-client.cnf /etc/my.cnf

RUN mkdir -p /app
WORKDIR /app

COPY ./onlystory/Gemfile /app/Gemfile
COPY ./onlystory/Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v 2.1.2 && bundle install --jobs 20 --retry 5

COPY ./onlystory /app

RUN apt-get remove -y build-essential dpkg-dev && apt-get clean

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENTRYPOINT ["/docker-entrypoint.sh"]
