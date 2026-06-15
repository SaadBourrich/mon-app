FROM node:20-alpine
RUN apk add --no-cache git
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY . .
ARG NEXT_PUBLIC_BASE_PATH=""
ENV NEXT_PUBLIC_BASE_PATH=$NEXT_PUBLIC_BASE_PATH
EXPOSE 3000
CMD ["npm", "run", "dev"]