FROM ubuntu:18.04
ENV DEVOPS = "George"
RUN apt update
RUN apt install -y apache2 --fix-missing
WORKDIR /app
COPY --chmod=0755 webservice-install.sh webservice-install.sh 
# RUN ["chmod", "+x", "/app/webservice-install.sh"]
RUN chmod 777 webservice-install.sh
RUN ["sh" ,"webservice-install.sh"]
# RUN /app/webservice-install.sh
CMD ["/usr/sbin/apache2ctl", "-D","FOREGROUND"]
EXPOSE 80