FROM ruby:2.7.3-alpine

COPY ./app /app/
WORKDIR /app/
RUN gem install bundler && bundle install

ENTRYPOINT ["ruby", "/app/main.rb"]