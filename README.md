[This README is also available in Spanish](README_es.md).

# README

Varacia is a Ruby on Rails-based web application for visualizing and managing the content of the tabletop role-playing system of the same name. It can currently be visited at: [web](https://rol.varacia.work.gd)

This application can be run either Docker containers (development mode) or as a normal Ruby on Rails application (production mode). To test it, Docker is recommended, where everything is already configured and it is the most convenient option.

## Development mode
To run it in *Docker*, follow these steps:

1. Install Docker (duh).

2. Run `docker compose up` in the root folder.

3. You can access the web interface at localhost:80. You may access the database on port 5555.

There is an admin system within the webpage for changing the data. You must set `admin_password` in rail's credentials to be able to access it, and then navigate to `/adminsession/new`.

## Docker Production mode
You can run this app as it is in production mode just by using `docker-compose.production.yml` insted of `docker-compose.yml`. For that you cun run `docker compose -f docker-compose.production.yml up`. Remember to add `--build` if you change from one mode to the other to properly rebuild the corresponding web server image. 

## Actual Production mode
To run this application correctly in your custom environment it is required you configure it properly via environment variables. You must check **VARS** and **PRODUCTION_REQUIRED_VARS** in *app/lib/env_vars*. Dotenv is used so you can configure them in `.env`.