# Experiment - Working with MongoDB and Grafana
:"I tried this on Linux Ubuntu 16.04(TLS) - but should be good on other Linuxes.
- Using the Mongo database "test1".
- Mongo server listening on port 27017
- The plugin listening on port 3333."

## Install Grafana and MongoDB packages.
## Install the mongodb-grafana Data source plugin (Free)
```
cd $HOME
git clone https://github.com/JamesOsgood/mongodb-grafana.git
cd mongodb-grafana/
sudo bash
cd /var/lib/grafana/plugins
cp -rp $HOME/mongo-grafana/mongodb-grafana .
systemctl restart grafana-server
cd mongodb-grafana
npm  install
```
Then run the plugin server:
```
npm run server --verbose
```
## Configure the data source in Grafana
```
Name: MongoDB
HTTP:
    URL: http://localhost:3333
    Access: Server (default)
Auth:
    None turned on
Custom HTTP headers:
    None
MongoDB details:
    MongoDB URL: mongodb://localhost:27017
    MongoDB Database: test1
```
## Exporting the DB collections..
```
mongoexport -d test1 -c test1 > test1.export
mongoexport -d test1 -c current > current.export
```
