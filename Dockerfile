# Sử dụng image Nginx chính thức
FROM nginx:alpine

# Copy nội dung của thư mục hiện tại vào thư mục html của Nginx
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80