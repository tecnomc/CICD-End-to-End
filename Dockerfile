FROM maven AS buildstage 
RUN mkdir /opt/tecnomc
WORKDIR /opt/tecnomc
COPY . .
RUN mvn clean install ###########---> *.war


FROM tomcat 
WORKDIR webapps
COPY --from=buildstage /opt/tecnomc/target/*.war .
RUN rm -rf ROOT && mv *.war ROOT.war
EXPOSE 8080
