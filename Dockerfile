# Use Nginx as the web server
FROM nginx:alpine

# Remove default Nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy portfolio website files
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY Swati_M_Resume.pdf /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]