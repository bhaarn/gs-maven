mvn clean
mvn compile
mvn package
java -jar target/gs-maven-0.1.0.jar
mvn test
mvn install
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=SonarQubeDemo \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=sqp_c03bd188516614a82f1dacbe92353444d72e3f24
/usr/bin/open -a "/Applications/Google Chrome.app" http://localhost:9000/dashboard?id=SonarQubeDemo
