# SimpleRent Tenant Application API README

## Project Setup

### First-time setup
1. install Ruby
2. download and install postgresql. https://www.postgresql.org/download
3. install RubyMine. https://www.jetbrains.com/ruby/download/#section=windows
4. in shell, run `gem install rails`
5. in shell, run `bundle install`

## Database and Master key
Ask for the database.yml and master.key files.

### Setup Database
1. `rails db:create`
2. `rails db:migrate`
3. `rails db:seed`

## Running app on localhost
1. Clone repo or pull master
2. `cd advanceme-api`
3. `bundle install`
4. `rails s` to run local server -- app will now be up on **localhost:3000**

---

## Software versions used

1. Ruby 2.7.4
2. Rails 6.1.4

---

## Local Setup as of February 01, 2022

1. Follow the instructions in **First-time setup**. (Note: Set the password of postgres to **root** when installing postgresql.)
2. Get a copy of `database.yml` and `master.key`.
3. Clone the repository.
4. Checkout to the development branch. `git fetch && git checkout deploy-to-dev`.
5. Copy the `database.yml` and `master.key` to `/config`.
6. Follow the instructions in **Setup Database**.
7. Make sure that the postgresql is running.
8. `cd sr_tenant_application_api`
9. `bundle install`
10. `rails s` to run local server -- app will be running on **localhost:3000**