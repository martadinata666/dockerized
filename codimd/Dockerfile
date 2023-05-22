
# Build webpack
FROM 192.168.0.2:5050/dedyms/codimd:dev AS frontend
RUN git clone -b develop --depth=1 https://github.com/hackmdio/codimd.git /codimd
WORKDIR /codimd
#RUN sed -i 's/npm/npm -d/g' bin/setup
RUN cp config.json.example config.json && \
    cp .sequelizerc.example .sequelizerc && \
    npm -d install --legacy-peer-deps && \
    npm -d run build

# Install prod
FROM 192.168.0.2:5050/dedyms/codimd:dev AS backend
RUN git clone -b develop --depth=1 https://github.com/hackmdio/codimd.git /codimd
WORKDIR /codimd
RUN npm -d install --only=prod --legacy-peer-deps && \
    rm -rf ./public
RUN rm -rf .git .gitignore .travis.yml .dockerignore .editorconfig .babelrc .mailmap .sequelizerc.example \
        test docs contribute \
        package-lock.json webpack.prod.js webpack.htmlexport.js webpack.dev.js webpack.common.js \
        config.json.example README.md CONTRIBUTING.md AUTHORS

# extract out
FROM 192.168.0.2:5050/dedyms/node:lts
USER $CONTAINERUSER
COPY --from=frontend --chown=$CONTAINERUSER:$CONTAINERUSER /codimd/public $HOME/codimd/public
COPY --from=backend --chown=$CONTAINERUSER:$CONTAINERUSER /codimd $HOME/codimd
WORKDIR $HOME/codimd
CMD ["node", "app.js"]
