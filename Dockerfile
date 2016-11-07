FROM rails:4.2

RUN echo "Australia/Melbourne" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
WORKDIR /usr/src/app

COPY Gemfile* ./

RUN bundle install

COPY . .

RUN rake db:create \
    && rake db:migrate

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
