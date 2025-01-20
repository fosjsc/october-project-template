# Development setup

1. Clone repo

    ```bash
        git clone --recurse-submodules -j8 git@github.com:fosjsc/october-project-template.git <project name>
    ```

2. Set Environment variables

    - `cp .env.example .env`
    - `cp laradock/.env.dev laradock/.env`
    - Set COMPOSE_PROJECT_NAME var in laradock/.env to project name
    - For another laradock env, see [https://laradock.io/docs/usage](https://laradock.io/docs/usage)

3. Set dns record

    - Run `sudo nano /etc/hosts`, add line `127.0.0.1       <project name>.test`

4. Run docker

    - `docker compose -f docker-compose.dev.yml up -d`

5. Enter the Workspace container, to execute commands like (Artisan, Composer, PHPUnit, Gulp, ...)

    - `docker compose exec --user=laradock workspace bash`

6. Follow october installation steps in workspace container. Access web at `http://<project name>.test`
