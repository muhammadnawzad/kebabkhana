# Kebabkhana

Kebabkhana is a simple web application that allows users to order kebabs online. The application is built using the [Crystal Language](https://github.com/crystal-lang/crystal) and [Marten Framework](https://github.com/martenframework/marten). Creating this application was a fun way to learn Crystal and Marten, and to build something useful for my colleagues at work. This project is not meant to be a production-ready application, but rather a learning exercise and a proof of concept.

## Background

Kebab day is a tradition at the office where I work. Every Thursday, we order kebabs from a local kebab shop. The process of ordering kebabs is a bit cumbersome. We have to write down our orders on a slack channel and then someone has to manually organize these orders and call the kebab shop to place the order. I thought it would be nice to have a web application that would allow us to order kebabs online. That's how Kebabkhana was born. The application is built around the idea of making it easy for us to order kebab, many of the features are tailored to our specific needs and are not necessarily generalizable to other use cases.

## Technologies

Kebabkhana is built using the following technologies:

- [Crystal Language](https://github.com/crystal-lang/crystal): A statically-typed, compiled programming language with a syntax similar to Ruby.
- [Marten Framework](https://github.com/martenframework/marten): A lightweight web framework for Crystal inspired by Ruby on Rails & Django.
- [PostgreSQL](https://www.postgresql.org/): A powerful, open-source object-relational database system.
- [Tailwind CSS](https://tailwindcss.com/): A utility-first CSS framework for rapidly building custom designs.
- [ESBuild](https://esbuild.github.io/): An extremely fast JavaScript bundler and minifier.
- [Docker](https://www.docker.com/): A platform for developing, shipping, and running applications in containers.
- [Kamal](https://kamal-deploy.org): A simple deployment tool for any type of web application. (Kamal V2 is used for the application deployment).
- [Flowbite](https://flowbite.com/): A free Tailwind CSS UI kit and components library.

## Features

Kebabkhana has 2 applications:

1. **Auth**: This application is based on the [Marten Auth](https://github.com/martenframework/marten-auth) shard and further customized to suit the needs of the Kebabkhana. It provides the following features:
   - User registration
   - User login
   - User logout
   - User profile
   - User password reset
   - User password change
   - User management (admin only)

2. **Kebabkhana**: This application is the main application that allows users to order kebabs online. It provides the following features:
    - Item management (create, read, update, delete).
    - Batch management (create, read, update, delete) - A batch is a collection of orders for a specific day (usually every Thursdays).
    - Order management (create, read, update, delete).
    - Order payment collection (the actual payment is done offline since we prefer to pay in cash).

## Installation

To install Kebabkhana, follow these steps:

1. Clone the repository and navigate to the project directory.
2. Install the required dependencies by running `shards install`.
3. Start the PostgreSQL database by running `docker-compose up -d`. (make sure to create a `.env` file with the required environment variables, and a development database).
4. Run the database migrations by running `marten migrate`.
5. Start the application by running `marten serve`.

## Deployment

Kebabkhana is deployed using [Kamal](https://kamal-deploy.org), a simple deployment tool for any type of web application. Use the following steps to deploy Kebabkhana on your server:

1. You need an amd64 server with a properly configured domain name.
2. Update the config/deploy.yml file with your server and domain information.
3. Update the .kamal/secrets.yml file with your database and secret key information.
4. Install Kamal on your server by following the instructions on the [Kamal website](https://kamal-deploy.org). Which is as simple as running `kamal setup`.
5. Run `kamal redeploy` to deploy new changes to your server.
