FROM ruby:3.0.0-alpine

RUN apk update && apk add bash build-base nodejs postgresql-dev tzdata shared-mime-info

RUN mkdir /project
WORKDIR /project

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.2.3 --no-document
RUN bundle install --no-binstubs --jobs $(nproc) --retry 3

COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
