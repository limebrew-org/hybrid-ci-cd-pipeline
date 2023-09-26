FROM node:18.16.1-alpine as build

WORKDIR /app 

COPY package.json .
COPY package-lock.json .

RUN npm i

COPY . .

RUN npm run build

FROM nginx:1.21-alpine as server

#? Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

#? Copy previous stage build into nginx serving directory
COPY --from=build /app/build /usr/share/nginx/html

#? Entry point
ENTRYPOINT ["nginx", "-g", "daemon off;"]