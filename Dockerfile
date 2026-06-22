FROM ruby:3.4.7-bookworm
WORKDIR /app

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV}

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY app/ app/
COPY bin/ bin/
COPY config/ config/
COPY lib/ lib/
COPY public/ public/
COPY Rakefile .
COPY config.ru .
COPY entrypoint.sh .

RUN if [ "$RAILS_ENV" = "production" ]; then \
    rm -rf /app/public/assets && \
    rails assets:precompile; \
  fi

EXPOSE 3000

ENTRYPOINT [ "./entrypoint.sh" ]

