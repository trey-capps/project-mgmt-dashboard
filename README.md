# project-mgmt-dasboard

# Backend Setup
## Pre Requisites
```cd backend```

```npm install```

Create an ```.env``` file with credentials as follows:
```
DB_HOST=
DB_PORT=
DB_USER=
DB_PASSWORD=
DB_NAME=
PORT=
```

## Database Start
(If using postgres via docker) ```cd infrastructure```
follow guide [here](./infrastructure/startup.md)


## Start Dev Server
```npx nodemon src/server.js```

use postman or curl to test the endpoints

If using postman use the collection [here](./backend/tests/postman/project-management-api.postman_collection.json)