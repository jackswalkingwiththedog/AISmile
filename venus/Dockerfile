FROM ubuntu:latest

RUN apt-get update 
RUN apt-get install -y python3
RUN apt-get clean

RUN mkdir /app/
COPY ./build /app/build

WORKDIR /app/build/web

EXPOSE 80

CMD ["python3", "server.py"]