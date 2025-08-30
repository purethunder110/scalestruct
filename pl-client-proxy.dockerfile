FROM node:24.7-slim

RUN npm install -g pnpm@latest-10

RUN git clone https://github.com/p-stream/simple-proxy

RUN cd simple-proxy

RUN pnpm i

RUN pnpm build

CMD pnpm start