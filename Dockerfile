# syntax-marker:deploy-f-generated-dockerfile-v1
FROM nginx:alpine
RUN find /usr/share/nginx/html -mindepth 1 -maxdepth 1 -exec rm -rf {} +
COPY [".", "/usr/share/nginx/html"]
WORKDIR /usr/share/nginx/html
RUN find . -type d -exec chmod 755 {} + && \
    find . -type f -exec chmod 644 {} +
RUN printf 'server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html index.htm;\n\
\n\
    gzip on;\n\
    gzip_vary on;\n\
    gzip_proxied any;\n\
    gzip_comp_level 6;\n\
    gzip_min_length 256;\n\
    gzip_types\n\
        text/plain\n\
        text/css\n\
        text/javascript\n\
        application/javascript\n\
        application/json\n\
        application/xml\n\
        image/svg+xml\n\
        font/woff2;\n\
\n\
    add_header X-Content-Type-Options "nosniff";\n\
    add_header X-Frame-Options "SAMEORIGIN";\n\
    add_header X-XSS-Protection "1; mode=block";\n\
    add_header Referrer-Policy "strict-origin-when-cross-origin";\n\
\n\
    location = / {\n\
        try_files /index.html =404;\n\
    }\n\
\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
\n\
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|map|webp|avif|json|webmanifest|mp4|webm)$ {\n\
        expires 1y;\n\
        add_header Cache-Control "public, immutable";\n\
        access_log off;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]