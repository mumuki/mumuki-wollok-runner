FROM java/openjdk-8-jdk
MANTAINER Franco Leonardo Bulgarelli
RUN wget http://download.uqbar.org/wollok/sdk/org.uqbar.project.wollok.launch-1.2.0-wdk.zip wdk.zip
RUN unzip wdk.zip
  
