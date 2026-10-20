FROM docker.io/library/node:20-bookworm-slim AS build

WORKDIR /app
COPY site/ .
RUN node .yarn/releases/yarn-4.12.0.cjs install --immutable

# Create React App bakes these into the bundle, so each chain gets its own image
ARG CHAIN
ARG API_END_POINT
ARG GRAPHQL_API_END_POINT
ENV REACT_APP_PUBLIC_CHAIN=$CHAIN \
	REACT_APP_PUBLIC_API_END_POINT=$API_END_POINT \
	REACT_APP_PUBLIC_GRAPHQL_API_END_POINT=$GRAPHQL_API_END_POINT \
	REACT_APP_PUBLIC_IDENTITY_SERVER_HOST=https://id.statescan.io \
	REACT_APP_DEFAULT_IPFS_GATEWAY=https://ipfs.filebase.io/ipfs/ \
	REACT_APP_PUBLIC_SIMPLE_MODE=true \
	REACT_APP_PUBLIC_MODE=production \
	GENERATE_SOURCEMAP=false
RUN node .yarn/releases/yarn-4.12.0.cjs build

FROM docker.io/library/nginx:1.27-alpine
COPY --from=build /app/build /usr/share/nginx/html
