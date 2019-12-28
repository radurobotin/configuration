FROM nginx:1.16.1-alpine

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## Copy our default nginx config template
COPY default.conf.template /etc/nginx/conf.d/

ENV BLOB_API http://blob-storage-api:18006/
ENV CORE_API http://core-web-api:18006/

COPY run_nginx.sh /usr/share
RUN chmod +x /usr/share/run_nginx.sh

CMD /usr/share/run_nginx.sh
