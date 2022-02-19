FROM ubuntu:latest

WORKDIR /dbt

RUN apt update && apt install -y \
	git \
	python3 \
	python3-pip \
	unixodbc-dev \
	unzip \
	wget
RUN wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.17/SimbaSparkODBC-2.6.17.0024-Debian-64bit.zip \
	&& unzip SimbaSparkODBC-2.6.17.0024-Debian-64bit.zip
RUN apt install -y \
	./SimbaSparkODBC-2.6.17.0024-Debian-64bit/simbaspark_2.6.17.0024-2_amd64.deb

RUN echo "[ODBC Drivers]\nSimba = Installed\n[Simba Spark ODBC Driver 64-bit]\nDriver = /opt/simba/spark/lib/64/libsparkodbc_sb64.so" >> /etc/odbcinst.ini

RUN pip3 install --no-cache-dir \
	dbt~=0.20.2 \
	dbt-spark[ODBC]~=0.20.2 \
	pyodbc~=4.0.32

RUN pip3 install --force-reinstall MarkupSafe==2.0.1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
