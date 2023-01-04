FROM nginx:1.23.3

WORKDIR /var/www/github-analyzer

# create log directory
RUN mkdir log

COPY ./.swarm/nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
