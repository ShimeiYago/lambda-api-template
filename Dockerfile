FROM ubuntu:20.04

RUN apt-get update && apt-get install -y python3-pip

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ARG APP_DIR="/app"

RUN mkdir ${APP_DIR}

COPY app.py ${APP_DIR}

COPY ./entry_script.sh /entry_script.sh
ADD ./aws-lambda-rie /usr/bin/aws-lambda-rie

WORKDIR ${APP_DIR}

ENTRYPOINT [ "/entry_script.sh" ]

CMD [ "app.handler" ]
