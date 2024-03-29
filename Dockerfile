FROM ruby:3.1.2-alpine

RUN apk add --update --virtual \
	runtime-deps \
	build-base \
	libpq-dev \
    postgresql-client \
    nodejs \
	yarn \
	git \
	tzdata \
	&& rm -rf /var/cache/apk/*

WORKDIR /sr_tenant_application_api
COPY . /sr_tenant_application_api/

ENV BUNDLE_PATH /gems
RUN yarn install
RUN bundle install

ENTRYPOINT ["bin/rails"]

CMD ["s", "-b", "0.0.0.0"]

EXPOSE 3000