FROM zenika/alpine-chrome:with-node

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1
ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium-browser
WORKDIR /usr/src/app

# Install pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -
COPY --chown=chrome .npmrc package.json pnpm-lock.yaml .pnpmfile.cjs ./
RUN pnpm install --frozen-lockfile --prod
COPY --chown=chrome . ./
ENTRYPOINT ["tini", "--"]
CMD ["/usr/src/app/headless.sh"]
