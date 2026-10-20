FROM docker.io/library/node:20-bookworm-slim

WORKDIR /app
COPY backend/ .
# Yarn defaults to Plug'n'Play here, so plain `node` could not resolve the workspace packages
ENV YARN_NODE_LINKER=node-modules
RUN node .yarn/releases/yarn-4.12.0.cjs install --immutable

ENV NODE_ENV=production
# Each service runs one package, for example `node packages/block-scan/src/index.js`
