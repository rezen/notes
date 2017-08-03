# RabbitMQ

```bash
# Export current config to a file
rabbitmqadmin -u admin -p test export rabbit.config

# Show list of vhosts
rabbitmqadmin -u admin -p test -f long -d 3 list vhosts
```

- https://www.slideshare.net/michaelklishin/rabbitmq-operations
- http://looselycoupledlabs.com/2014/08/monitoring-rabbitmq/
- http://jaredrobinson.com/Scaling_RabbitMQ/
- https://www.slideshare.net/nahidupa/scaling-application-with-rabbitmq-44485159
- https://www.cloudfoundry.org/scaling-real-time-apps-on-cloud-foundry-using-node-js-and-rabbitmq/
- https://www.rabbitmq.com/management.html
- http://devops.datenkollektiv.de/creating-a-custom-rabbitmq-container-with-preconfigured-queues.html
- https://medium.com/@thomasdecaux/deploy-rabbitmq-with-docker-static-configuration-23ad39cdbf39