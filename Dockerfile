## start by pulling the python image
FROM python:3.8-alpine

ADD app /app

ADD requirements.txt /

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

CMD python3, app/app.py
