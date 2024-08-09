# Docker Container with PostgreSql utilities

This Docker container is based on the Alpine Linux distribution and includes several utilities such as curl, vim, bash, postgresql16-client, and the MinIO client (mc).


## Build

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t pgclient:latest .
```

The image is also build with every release and published to `docker.io/cgerull/pglient`

## Usage

Run the image as standalone postgresql client to perform backup and restores or embed it in a deployment.


To run the Docker container:

The container is configured to run indefinitely with the command tail -f /dev/null. This allows you to attach to the container and use the included utilities interactively.

```bash
docker run --name pgclient \
    --rm \
    -e PGHOST=localhost \
    -e PGUSER=postgres \
    cgerull/pgclient:<tag>

docker exec -it pgclient bash
```

## Example Commands
Once inside the container, you can use the included utilities as follows:

curl: curl https://example.com
vim: vim filename
bash: bash
PostgreSQL client: psql -h hostname -U username -d database
MinIO client: mc ls myminio

## Included Software
Alpine Linux 3.20: A minimal Docker image based on Alpine Linux.
curl: Command-line tool for transferring data with URLs.
vim: A highly configurable text editor.
bash: The Bourne Again SHell.
postgresql16-client: PostgreSQL client tools.
MinIO Client (mc): A modern alternative to UNIX commands like ls, cat, cp, and mirror.

## Notes
The MinIO client (mc) is downloaded from the official MinIO release for Linux ARM64 and placed in /usr/bin/mc.
The container does not start any services by default; it is intended for interactive use.
License
This project is licensed under the MIT License. See the LICENSE file for details.
