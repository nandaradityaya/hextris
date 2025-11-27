FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Hapus file default nginx
RUN rm -rf ./*

# Copy semua file Hextris
COPY . .

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

