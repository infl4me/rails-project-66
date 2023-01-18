FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install -g yarn

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

COPY . ./

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
