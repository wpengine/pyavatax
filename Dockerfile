FROM python:3.6-alpine

RUN mkdir /app
WORKDIR /app
COPY setup.py requirements.txt ./

# Install dependencies of setup.py, but NOT the package itself.
# (We'll mount that at /app/.)
RUN pip install -e . && pip uninstall --yes pyavatax

# Install dev requirements:
RUN pip install -r requirements.txt

