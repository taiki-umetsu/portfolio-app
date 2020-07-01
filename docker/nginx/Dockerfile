# when building the image, being needed to upload only /portfolio-app/docker/nginx/files to docker deamon
# therefore, at /portfolio-app/docker/nginx/, input this command
# docker build .
FROM nginx:1.19
RUN apt-get update && \
  apt-get install -y apt-utils \
  locales && \
  echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
ARG NGINX_HOST_NAME=www.kaoreal.com
# Using environment variables in nginx configuration
RUN envsubst '$$NGINX_HOST_NAME' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
