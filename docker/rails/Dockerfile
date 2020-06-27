# when building the image, being needed to upload rails app to docker deamon 
# therefore, at /portfolio-app, input this command
# docker build -f docker/rails/Dockerfile .
FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs 
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
  apt-get install nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

COPY ./docker/rails/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "s", "-e", "production"]