FROM ruby:3.0.0

ENV RAILS_ENV production
RUN mkdir /mangosteen
RUN bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems/
WORKDIR /mangosteen
ADD mangosteen-*.tar.gz ./
RUN bundle config set --local without 'development test'
RUN bundle install 
ENTRYPOINT bundle exec puma