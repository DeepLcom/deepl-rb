ARG RUBY_IMAGE
FROM ${RUBY_IMAGE}-alpine

RUN apk add --no-cache alpine-sdk ruby-dev

RUN adduser -D rubytester
USER rubytester
WORKDIR /home/rubytester

