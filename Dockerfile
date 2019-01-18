FROM node:10.6.0 as builder
SHELL ["/bin/bash", "-c"]

WORKDIR /function-app
COPY . .

RUN yarn install

RUN apt-get update && \
    wget https://dot.net/v1/dotnet-install.sh && \
    source dotnet-install.sh --channel Current && \
    rm dotnet-install.sh && \
    npm i -g azure-functions-core-tools@core --unsafe-perm true && \
    func extensions install

FROM mcr.microsoft.com/azure-functions/node:2.0

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-liberation \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# Define required envvars
ENV AzureWebJobsScriptRoot=/home/site/wwwroot
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

WORKDIR /home/site/wwwroot
RUN npm i && npm i puppeteer@1.11.0
COPY --from=builder /function-app /home/site/wwwroot