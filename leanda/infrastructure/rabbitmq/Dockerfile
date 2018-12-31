FROM rabbitmq:3.6-management

RUN apt-get update

RUN apt-get install -y curl

RUN mkdir /usr/lib/rabbitmq/plugins

RUN curl http://www.rabbitmq.com/community-plugins/v3.6.x/rabbitmq_delayed_message_exchange-0.0.1.ez > /usr/lib/rabbitmq/plugins/rabbitmq_delayed_message_exchange-0.0.1.ez

RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

HEALTHCHECK --timeout=2s CMD curl -sf -u guest:guest http://localhost:15672/api/healthchecks/node || exit 1