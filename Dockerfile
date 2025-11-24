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

RUN if [ "$RAILS_ENV" = "production" ]; then \
    rm -rf /app/public/assets && \
    rails assets:precompile; \
  fi

EXPOSE 3000

# Puto tmp (hay que borrarlo para evitar errores, ni idea de porqué)
# iniciar rails
CMD rm -rf /app/tmp/* && bin/rails server -b 0.0.0.0 -e ${RAILS_ENV}
