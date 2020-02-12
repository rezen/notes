kafka-consumer-groups --bootstrap-server kafka.example.com:9092 --list | grep health | xargs -I{} kafka-consumer-groups --bootstrap-server kafka.example.com:9092 --describe --group {}
