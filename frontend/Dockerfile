FROM node:18-alpine

WORKDIR /app

# Install serve pour servir les fichiers statiques
RUN npm install -g serve

COPY package*.json ./
RUN npm install

COPY . .

# Build l'application
RUN npm run build

EXPOSE 3000

# Servir l'application buildée
CMD ["serve", "-s", "build", "-l", "3000"]

