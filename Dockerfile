FROM public.ecr.aws/lambda/python:3.11.2023.11.01.21-x86_64
ENV PGVERSION 13.13

RUN yum update -y \
  && yum install -y tar gzip gcc python3-devel python3-pip python3-setuptools libxml2-devel libxslt-devel readline-devel uuid-devel openssl \
  && yum clean all

RUN curl -O https://ftp.postgresql.org/pub/source/v${PGVERSION}/postgresql-${PGVERSION}.tar.gz \
  && tar -xvf postgresql-${PGVERSION}.tar.gz \
  && cd postgresql-${PGVERSION} \
  && ./configure \
  && make -j4 \
  && make install \
  && cd .. \
  && rm -rf postgresql-${PGVERSION} postgresql-${PGVERSION}.tar.gz

COPY src/*.py $LAMBDA_TASK_ROOT
COPY src/requirements.txt $LAMBDA_TASK_ROOT

RUN pip install --upgrade pip \
  && pip install -r requirements.txt

CMD ["handler.main"]
