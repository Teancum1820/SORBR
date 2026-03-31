FROM nginx:1.25-alpine

# Remove default nginx site
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/sorbr.conf

# Copy app files
COPY index.html /usr/share/nginx/html/index.html
COPY manifest.json /usr/share/nginx/html/manifest.json
COPY sw.js /usr/share/nginx/html/sw.js
COPY icons/ /usr/share/nginx/html/icons/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
