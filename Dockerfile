FROM nginx:alpine

ARG ENV_TYPE=blue

COPY ${ENV_TYPE}/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]