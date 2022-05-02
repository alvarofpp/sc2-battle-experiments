FROM alvarofpp/s2client:4.10 AS s2client
FROM python:3.10-slim

# Install SC2
COPY --from=s2client /root/StarCraftII /root/StarCraftII

# Virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install requirements
RUN pip3 install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Set environment variables
ENV WORKDIR=/app
WORKDIR ${WORKDIR}
