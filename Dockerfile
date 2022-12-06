############################
# STEP 1 build executable binary
############################

# Copy local code to the container image.
FROM zenika/alpine-chrome:with-node as builder
WORKDIR /app

# Copy local code to the container image.
USER root

# Build the command inside the container (You may fetch or manage dependencies here)
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates \
    apk add --no-cache tini curl \
    curl -f https://get.pnpm.io/v6.js | node - add --global pnpm

# Create appuser
RUN adduser -D -g '' appuser

COPY --chown=chrome .npmrc package.json pnpm-lock.yaml .pnpmfile.cjs ./
RUN pnpm install --frozen-lockfile --prod

###########################
# STEP 2 build a small image
############################
FROM zenika/alpine-chrome:with-node
WORKDIR /app

# Import from builder
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/node_modules ./node_modules

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium-browser

COPY --chown=chrome . ./
ENTRYPOINT ["tini", "--"]

# Use an unprivileged user.
USER appuser

CMD ["/app/headless.sh"]
