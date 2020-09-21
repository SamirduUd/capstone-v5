FROM nginx
#RUN rm /usr/share/nginx/html/index.html
COPY index.html C:\nginx-1.19.2\nginx-1.19.2\html
