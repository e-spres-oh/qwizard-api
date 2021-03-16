## Using Docker

<!-- used for building the container-->
* docker-compose build
<!-- create the docker db -->
* docker-compose run api bundle exec rails db:create
<!-- run the migration on docker db -->
* docker-compose run api bundle exec rails db:migrate
<!-- used for starting the apps -->
* docker-compose run --service-ports api