sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false prometheus


sudo wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz
sudo mkdir -p /data /etc/prometheus
cd prometheus-2.47.1.linux-amd64/

#Move the Prometheus binary and a promtool to the /usr/local/bin/. promtool is used to check configuration files and Prometheus rules.
sudo mv prometheus promtool /usr/local/bin/


#Move console libraries to the Prometheus configuration directory
sudo mv consoles/ console_libraries/ /etc/prometheus/

#Move the example of the main Prometheus configuration file
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

#Set the correct ownership for the /etc/prometheus/ and data directory
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/