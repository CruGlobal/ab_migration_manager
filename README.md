# (AppBuilder) A tool to apply DB schema updates to a running site.
Migrate from an older version of AppBuilder to a newer one.


## Installation

This tool is published as a docker image: `docker.io/digiserve/ab-migration-manager:master`. You don't need to install anything before use. There is also no need to modify your docker-compose.yml file for this.


## Usage

Make sure the AppBuilder stack is running. Then run the `ab-migration-manager` image, connecting it to the AppBuilder stack's network. There may already be a convenience script (like `pod-migrate.sh`) in your AppBuilder directory to help you do this. If not, you may want to create it yourself.

### Docker

```sh
    #!/bin/bash

    STACKNAME=example_appbuilder_stack

    docker run \
        -v ./config/local.js:/app/config/local.js \
        --network=${STACKNAME}_default \
        digiserve/ab-migration-manager:master node app.js
```

### Podman
```sh
    #!/bin/bash

    # Import STACKNAME and MYSQL_PASSWORD from the .env file
    source .env

    podman run \
        -v ./config/local.js:/app/config/local.js \
        --network=${STACKNAME}_default \
        -e MYSQL_PASSWORD \
        docker.io/digiserve/ab-migration-manager:master node app.js
```

After you finish running the tool, you should restart your AppBuilder stack.
