# RGM Downtime Interface

This interface is designed to delegate maintenance to non IT persons.  
His vocation is to be easy to setup maintenance on high level application (Business Process) with a basic form.

Each application must be setup through a `yaml` formated file (See [template.yml](app_configs/template.yml))

## Deploy

All application is designed to run in docker container.  
To create image you could just run :

```bash
git clone --branch master https://github.com/vfricou/rgm_downtime_interface
cd rgm_downtime_interface
docker build -t rgm_dwt:latest .
```

When image build is finished, modify [docker-compose.yml](docker-compose.yml) file according to your 
environment and launch container :

```bash
docker-compose up -d
```

## Environment

| Variable | Default value | Mandatory | Description |
| --- | --- | --- | --- |
| RGMDWT_SUBMIT_USER| 'Robot' | False | Username displayed in downtime into RGM interface |
| RGMDWT_APP_PATH | 'app_configs' | False | Folder where applications configurations was stored |
| RGMDWT_API_SERVER | '192.168.56.101' | True | RGM Host |
| RGMDWT_API_USERNAME | 'admin' | True | RGM Username with downtime hability |
| RGMDWT_API_PASSWORD | 'admin' | True | RGM Password matching username |
| MAIL_HOST | nil | False (True for email notifs) | Mail server used to send emails |
| MAIL_POST | nil | False (True for email notifs) | Mail server port |
| MAIL_USER | nil | False | Mail server user if needed |
| MAIL_PASS | nil | False | Mail server password if needed |
| MAIL_AUTH_TYPE | nil | False | Mail server authentication if needed |
| MAIL_HELO | nil | False (True for email notifs) | Mail EHLO flag for session openning |
| MAIL_SSL_ENABLE | nil | False | Mail server SSL if needed |
| MAIL_FROM | 'RGM Downtime <no-reply@example.loc>' | False (True for email notifs) | Email sender | 
| MAIL_SUBJECT | 'RGM - New downtime apposed' | False (True for email notifs) | Email subject
| TZ | 'Europe/Paris' | True | Timezone to get right datetime for downtime |
