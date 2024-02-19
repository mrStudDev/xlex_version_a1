FROM python:3.12.2-alpine3.18
LABEL maintainer="marcosscfloripa@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1

COPY ./xlexapp /xlexapp
COPY ./scripts /scripts

WORKDIR /xlexapp

EXPOSE 8000

RUN apk add --no-cache build-base python3-dev libffi-dev openssl-dev

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel && \
    /venv/bin/pip install -r /xlexapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts\


ENV PATH="/scripts:/venv/bin:$PATH"

USER duser
CMD ["commands.sh"]

