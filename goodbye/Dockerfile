FROM ruby:2.5.1

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    nodejs \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

# Pre-install gems with native extensions
RUN gem install nokogiri -v "1.8.5"

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

CMD script/start
