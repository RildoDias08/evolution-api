# Estágio de construção
FROM node:18-alpine AS builder

LABEL version="1.8.0" description="Api to control whatsapp features through http requests."
LABEL maintainer="Davidson Gomes" git="https://github.com/DavidsonGomes"
LABEL contact="contato@agenciadgcode.com"

# Instala as dependências do sistema
RUN apk update && apk upgrade && \
    apk add --no-cache git tzdata ffmpeg wget curl

# Cria o diretório de trabalho
WORKDIR /evolution

# Copia o package.json
COPY package.json ./

# Instala as dependências do Node.js
RUN npm install

# Copia o restante dos arquivos
COPY . .

# Executa o build
RUN npm run build

# Estágio final
FROM node:18-alpine AS final

ENV TZ=America/Sao_Paulo
ENV DOCKER_ENV=true

# Define variáveis de ambiente
ENV SERVER_TYPE=http
ENV SERVER_PORT=8080
ENV SERVER_URL=http://localhost:8080

# (mantenha as demais variáveis de ambiente conforme seu original)

# Define o diretório de trabalho
WORKDIR /evolution

# Copia os arquivos do estágio de builder
COPY --from=builder /evolution .

# Comando para iniciar a aplicação
CMD [ "node", "./dist/src/main.js" ]
