# SimpleRent Tenant Application API

## Prerequisites
[![Ruby Style Guide](https://img.shields.io/badge/Ruby-3.1.2-red)](https://www.ruby-lang.org/en/news/2022/04/12/ruby-3-1-2-released)
[![Ruby Style Guide](https://img.shields.io/badge/Rails-7.0.3-brightgreen)](https://rubygems.org/gems/rails)

### First-time setup
1. install Ruby
2. download and install postgresql. https://www.postgresql.org/download
3. install RubyMine. https://www.jetbrains.com/ruby/download/#section=windows
4. **Run** the following command.
```bash
$ gem install rails
```
```bash
$ bundle install
```

## Database and Master key
Ask for the database.yml and master.key files.

### Setup Database
```bash
$ rails db:create
```
```bash
$ rails db:migrate
```
```bash
$ rails db:seed
```

## Running app on Docker
1. Change the host in config/database.yml to 'db'.
2. Install Docker. https://docs.docker.com/desktop/windows/install/
3. **Run** the following command. Or click on the Run icon beside services in docker-compose.yml.
```bash
$ docker-compose up
```
4. Run in a another terminal to migrate and seed data.
```bash
$ docker-compose run web rake db:create db:migrate db:seed
```

The server will run on **localhost:3000**.

---

## Running app on localhost
1. Clone the repo or pull deploy-to-dev branch.
2. **Run** the following command.
```bash
$ cd sr_tenant_application_api
```
```bash
$ bundle install
```
```bash
$ rails s
```
The server will run on **localhost:3000**.

---

## Local Setup as of February 18, 2022

1. Follow the instructions in **First-time setup**. (Note: Set the password of postgres to **root** when installing postgresql.)
2. Get a copy of `database.yml` and `master.key`.
3. Clone the repository.
4. Checkout to the development branch.
```bash
$ git fetch && git checkout deploy-to-dev
```
5. Copy the `database.yml` and `master.key` to `/config`.
6. **Run** the following command to setup the database.
```bash
$ rails db:create db:migrate db:seed
```
7. Make sure that the postgresql is running. (In Ubuntu's case, run the following command)
```bash
$ sudo service postgresql start
```
9. **Run** the following command to setup the project.
```bash
$ cd sr_tenant_application_api
```
```bash
$ bundle install
```
```bash
$ rails s
```
The server will run on **localhost:3000**.

---
### Testing
```bash
$ rspec spec/requests
```
---

### Folder Structure
1. **Model** - It contains the models and data stored in our application's database.
2. **View** - This folder contains the display templates to fill data in our application.
3. **Controller** - All the controller files are stored here. A controller handles all the web requests from the user.
4. **Interactors** - This folder have the appilcations business logic. It is called in controllers or organizers.
5. **Queries** - It is a query object pattern that helps in decomposing the fat ActiveRecord models and keeping the code slim and readable by extracting complex SQL queries or scopes into the separated classes that are easy to reuse and test. This is currently used in Profile.
6. **Serializers** - It convert a given object into a JSON format. Serializers control the particular attributes rendered when an object or model is converted into a JSON format.
7. **Uploaders** - Carrierwave stores the configuration in this folder. Uploaders are included into some models.
8. **Validators** - Custom validation for interactors.
9. **Services** - It is a object pattern that can help separate business logic from controllers and models, enabling the models to be simply data layers and the controller entry point to the API.