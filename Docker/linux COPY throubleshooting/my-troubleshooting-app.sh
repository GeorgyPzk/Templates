FROM registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3
RUN apt-get update -y && apt-get install curl -y
WORKDIR /app
COPY ./my-troubleshooting-app.sh .
CMD ["./my-troubleshooting-app.sh"]
$cat my-troubleshooting-app.sh 
#!/bin/bash
while true; do echo -n "$(date) "; curl -s -o /dev/null -w "%{time_total} %{http_code}\n" $HOST -k; sleep $INTERVAL; done