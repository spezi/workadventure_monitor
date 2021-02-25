# workadventure_monitor
Simple monitoring for workadventure and jitsi.

It consists of prometheus, grafana and caddy. Caddy is used due to it simple revers proxy function and automatic LE cert retrieval and renewal.

## Requirements
* workadvanture installtion
* jitsi server
  * https://github.com/systemli/prometheus-jitsi-meet-exporter
### Additional requirements
* https://github.com/prometheus/node_exporter on the WA host and the jitsi host

**WARNING**: All stats that are polled are unencrypted and unauthenticated. Make sure to switch to TLS and basic auth. Securing your stats is not part of this document.

# Installation
## prometheus jitsi meet exporter
First you need to install the prometheus-jitsi-meet-exporter on your jitsi server. Please follow the instructions to activate the colibri stats in jitsi.

If you run the jvb as a docker container you could add these to the `JVB` environment:
```
JVB_ENABLE_STATISTICS=true
JVB_STATISTICS_TRANSPORT=muc,colibri
```

And also add this to the docker-compose.yml
```yaml
    promexport:
        image: systemli/prometheus-jitsi-meet-exporter:latest
        restart: ${RESTART_POLICY}
        command: -videobridge-url http://jvb:8080/colibri/stats
        ports:
            - '9888:9888'
        depends_on:
            - jvb
        networks:
            meet.jitsi:
```

After the prometheus exporter has been started you should be able to get the statistics via `http://localhost:9888/metrics`.

## install stack
```sh
git clone https://github.com/spezi/workadventure_monitor.git
cd workadventure_monitor
./pre-run.sh
```

Now you need to modify your [prometheus/etc/prometheus.yml](prometheus/etc/prometheus.yml) and set the correct domain names.

Make sure to change the `grafana.example.com` hostname to your machines hostname in [docker-compose.yml](docker-compose.yml)

Once you are done you should be able to start it via
```
docker-compose up -d
```

After a short while you should be able to login into grafana with `admin` `admin`.
Then you add the prometheus datasource with URL `prometheus:9090`.
Once this is done you just add [this dashborad](https://github.com/systemli/prometheus-jitsi-meet-exporter/blob/master/dashboards/jitsi-meet.json)


And if everything works you can just create another "graph" panel and use `workadventure_nb_clients_per_room` as PromQL query.

# License
>You can check out the full license [here](LICENSE.txt)

This project is licensed under the terms of the **MIT** license.

