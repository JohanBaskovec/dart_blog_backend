## Initial setup
### Postgresql
* install Docker
* run a postgres Docker image
```
docker run --name postgres -e POSTGRES_PASSWORD=c4ef37c0fbd747da1c63c0f87d7c62df --network="host" postgres:9.6 
```
This will download the postgres 9.6 image, run it in a container named "postgres",
create a database called "postgres", 
create a user "postgres" with a password (used exclusively for the 
local development database) and listen to port 5432.

## Running
Run using pub:
```
pub run main.dart
```
