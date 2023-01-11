##
## digiserve/ab-migration-manager:[master/develop]
##
## This is our utility for managing DB migrations for a running platform.
##
## Docker Commands:
## ---------------
## $ docker build -t digiserve/ab-migration-manager:[master/develop] .
## $ docker push digiserve/ab-migration-manager:[master/develop]
##

ARG BRANCH=master

FROM digiserve/service-cli:${BRANCH}

COPY . /app

WORKDIR /app

RUN npm i -f

CMD ["node", "--inspect=0.0.0.0:9229", "app.js"]
