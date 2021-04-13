#!/bin/bash
set -e -x
nohup java -jar /home/ubuntu/spring-petclinic-rest.jar --spring.datasource.url=jdbc:postgresql://${DATABASE_HOST}/${DATABASE_NAME} --spring.datasource.username=${DATABASE_USERNAME} --spring.datasource.password=${DATABASE_PASSWORD} --spring.datasource.driver-class-name=org.postgresql.Driver > /var/log/petclinic.out /dev/null &