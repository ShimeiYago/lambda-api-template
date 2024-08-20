FROM tensorflow/tensorflow:2.16.2

RUN apt-get update && apt-get install -y python3-pip

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ARG APP_DIR="/app"

RUN mkdir ${APP_DIR}

COPY app.py ${APP_DIR}

COPY ./entry_script.sh /entry_script.sh
ADD ./aws-lambda-rie /usr/bin/aws-lambda-rie

# ここから
ARG MODEL_DIR="${APP_DIR}/models"
RUN mkdir -p ${MODEL_DIR}
COPY models/vgg16_weights_tf_dim_ordering_tf_kernels.h5 ${MODEL_DIR}
COPY models/imagenet_class_index.json ${MODEL_DIR}
ENV TF_CPP_MIN_LOG_LEVEL="2"
# ここまで追加

WORKDIR ${APP_DIR}

ENTRYPOINT [ "/entry_script.sh" ]

CMD [ "app.handler" ]
