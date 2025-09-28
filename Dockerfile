FROM python:3.10-slim

# Keep Python leaner and logs unbuffered
ENV PYTHONDONTWRITEBYTECODE=1 \
	PYTHONUNBUFFERED=1

COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

ARG APP_DIR="/app"

RUN mkdir ${APP_DIR}

COPY app.py ${APP_DIR}

COPY ./entry_script.sh /entry_script.sh
RUN chmod +x /entry_script.sh

WORKDIR ${APP_DIR}

ENTRYPOINT [ "/entry_script.sh" ]

CMD [ "app.handler" ]
