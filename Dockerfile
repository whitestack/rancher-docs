ARG BASE_IMAGE=us-east1-docker.pkg.dev/whitestack-public-docs/whitestack-public-docs/docs-gateway-base:latest
FROM ${BASE_IMAGE}

COPY build /usr/local/openresty/nginx/html
