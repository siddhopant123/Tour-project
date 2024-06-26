# Use an official Nginx image as the base image
FROM nginx:alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Copy the contents of the current directory to the working directory in the container
COPY . .

# Expose port 80 to allow external access to the web server
EXPOSE 80

# Command to start the Nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]
