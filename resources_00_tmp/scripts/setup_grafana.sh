#!/bin/bash

########################################################
export KAFKA_HOME_DIR=/home/kafka
export KAFKA_HOME=/home/kafka/softwares/kafka
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside the setup_grafana shell script.....pwd is: $(pwd), running as : [$(whoami)]"


sudo systemctl stop grafana

sudo rm -rf /var/log/grafana
sudo mkdir -p /var/log/grafana
sudo chown -R kafka:kafka /var/log/grafana


setupService_grafana() {

    echo  "

    [Unit]
    Description=grafana
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=kafka
    Type=simple
    ExecStart=${KAFKA_HOME_DIR}/softwares/grafana/bin/grafana server --homepath ${KAFKA_HOME_DIR}/softwares/grafana cfg:default.paths.logs=/var/log/grafana/grafana.log

    [Install]
    WantedBy=multi-user.target
    " |  sudo tee /etc/systemd/system/grafana.service

    echo "==========>>>>>> Content of file /etc/systemd/system/grafana.service"
    sudo cat /etc/systemd/system/grafana.service
}


setupService_grafana

sudo systemctl daemon-reload
sudo systemctl enable grafana
sudo systemctl start grafana