FROM darthjee/ruby_240:0.2.2

USER app
COPY ./ /home/app/app/

RUN ls

RUN bundle install

