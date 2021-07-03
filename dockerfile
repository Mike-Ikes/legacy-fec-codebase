# pull official base image
#FROM node:14

# set working directory
#WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
#ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
#COPY package.json ./
#COPY package-lock.json ./
#RUN npm install --silent
#RUN npm install react-scripts@3.4.1 -g --silent

# add app
#COPY . ./

##ENV PORT=4200

#EXPOSE 4200

# start app
#CMD ["npm", "start"]

# build environment
FROM node:lts-alpine3.12 as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts -g --silent
COPY . ./
RUN npm run build-prod

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
# new
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 4200
CMD ["nginx", "-g", "daemon off;"]