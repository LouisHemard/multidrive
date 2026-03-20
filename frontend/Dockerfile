FROM node:18-alpine

WORKDIR /app

RUN npm install -g serve

COPY package*.json ./
RUN npm install

COPY . .

ARG REACT_APP_API_URL=http://localhost:8000
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

RUN npm run build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]

