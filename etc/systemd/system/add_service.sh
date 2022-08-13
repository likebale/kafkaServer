

sudo ln -s /usr/local/zookeeper/conf/zookeeper.service zookeeper.service
sudo systemctl status zookeeper.service
sudo systemctl daemon-reload
sudo systemctl enable zookeeper.service


sudo ln -s /usr/local/kafka/config/kafka.service kafka.service
sudo systemctl status kafka.service
sudo systemctl daemon-reload
sudo systemctl enable kafka.service
