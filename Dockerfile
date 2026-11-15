FROM python:3.9.16-slim

ENV PYTHONBUFFERED 1
ENV PYTHONWRITEBYTECODE 1

RUN apt-get update     && apt-get install -y netcat-openbsd

ENV APP=/app

WORKDIR $APP

COPY requirements.txt $APP

RUN pip3 install -r requirements.txt

COPY . $APP

EXPOSE 8000

RUN chmod +x /app/entrypoint.sh

# OpenShift runs the container as a random user in group 0, so let that group write the app folder (SQLite database)
RUN chgrp -R 0 /app && chmod -R g=u /app

ENTRYPOINT ["/bin/bash","/app/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
