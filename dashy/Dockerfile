#syntax=docker/dockerfile:1.4
FROM 192.168.0.2:5050/dedyms/node:lts-dev

# Define some ENV Vars
ENV PORT=80 \
    IS_DOCKER=true

# Create and set the working directory
#WORKDIR $HOME

# Copy over both 'package.json' and 'package-lock.json' (if available)
#COPY package*.json ./
#COPY yarn.lock ./

USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/Lissy93/dashy.git $HOME/dashy
WORKDIR $HOME/dashy
# Install project dependencies
RUN yarn

# Copy over all project files and folders to the working directory
#COPY . .

# Build initial app for production
RUN yarn build

# Expose given port
EXPOSE ${PORT}

# Finally, run start command to serve up the built application
CMD [ "yarn", "build-and-start"]

# Run simple healthchecks every 5 mins, to check the Dashy's everythings great
HEALTHCHECK --interval=5m --timeout=2s --start-period=30s CMD yarn health-check
