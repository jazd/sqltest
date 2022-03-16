FROM python:2.7

RUN apt-get update
RUN apt-get install -y python-pip libyaml-dev libpython2.7-dev

RUN /usr/local/bin/python -m pip install --upgrade pip

RUN pip install pyyaml mysql-connector psycopg2

