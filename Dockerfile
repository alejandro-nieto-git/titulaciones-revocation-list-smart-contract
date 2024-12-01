FROM node:18

WORKDIR /app

COPY . .

RUN npm install
RUN chmod +x entrypoint.sh

EXPOSE 8545

CMD ["./entrypoint.sh"]
