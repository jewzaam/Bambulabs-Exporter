# Bambulabs Exporter

- [Supported Models](#supported-models)
- [Collected Metrics](#collected-metrics)
- [Steps to run the exporter](#steps-to-run-the-exporter)
  - [Step 0: Prereqs](#step-0-prereqs)
  - [Step 1: env File](#step-1-env-file)
  - [Step 2: Clone the repo](#step-2-clone-the-repo)
  - [Step 3: Run Docker Compose](#step-3-run-docker-compose)
- [Bugs](#bugs)
- [Feature Changes](#feature-changes)
- [Future Development](#future-development)
- [Credit](#credit)
- [Support Questions](#support-questions)

This repository hosts a Prometheus Exporter for Bambu Labs 3D printers written in Go. It collects
metrics from the device MQTT report topic.

A Docker image is available at: <https://hub.docker.com/r/aetrius/bambulabs-exporter>.

## Supported Models

| Model | Tested Firmware |
| ----- | --------------: |
| A1    |     01.03.01.00 |
| X1    |     01.04.01.00 |

## Collected Metrics

> [!TIP]
> Sample Metrics available [here](sample.md).
>
> *annotates recent changes or additions.

| Metric                      | Description                                                                    |            Examples |
| --------------------------- | ------------------------------------------------------------------------------ | ------------------: |
| ams_humidity_metric         | Humdity of the Enclosure, includes the AMS Number 0-many                       |                   4 |
| ams_temp_metric             | *Temperature of the AMS, includes the AMS Number 0-many                        |                30.7 |
| ams_tray_color_metric       | *Filament color in the AMS, includes the AMS Number 0-many & Tray Numbers 0-4  | tray_color=000000FF |
| ams_bed_temp_metric         | *Temperature of the AMS bed, includes the AMS Number 0-many & Tray Numbers 0-4 |                   0 |
| big_fan1_speed_metric       | Big1 Fan Speed                                                                 |                   0 |
| big_fan2_speed_metric       | Big2 Fan Speed                                                                 |                   0 |
| chamber_temper_metric       | Temperature of the Bambu Enclosure                                             |                  30 |
| cooling_fan_speed_metric    | Print Head Cooling Fan Speed                                                   |                   0 |
| fail_reason_metric          | Failure Print Reason Code                                                      |                   0 |
| fan_gear_metric             | Fan Gear                                                                       |                   0 |
| layer_number_metric         | GCode Layer Number of the Print                                                |                 261 |
| mc_percent_metric           | Print Progress in Percentage                                                   |                  36 |
| mc_print_error_code_metric  | Print Progress Error Code                                                      |                   0 |
| mc_print_stage_metric       | Print Progress Stage                                                           |                   2 |
| mc_print_sub_stage_metric   | Print Progress Sub Stage                                                       |                   4 |
| mc_remaining_time_metric    | Print Progress Remaining Time in minutes                                       |                1973 |
| nozzle_target_temper_metric | Nozzle Target Temperature Metric                                               |                   0 |
| nozzle_temper_metric        | Nozzle Temperature Metric                                                      |                 221 |
| print_error_metric          | Print Error reported by the Control board                                      |                   0 |
| wifi_signal_metric          | Wifi Signal Strength in dBm                                                    |                 -40 |

## Steps to run the exporter

> [!TIP]
> Also available: [Exporter Setup Video](https://www.youtube.com/watch?v=E80Y5kTJaNM&ab_channel=TylerBennet).

### Step 0: Prereqs

This project assumes you have a Grafana/Prometheus Setup. You would point your Prometheus instance
to the (host:9101) endpoint.

This program/container would run on a virtual host, raspberry pi, or a computer that has access to
the BambuLabs printer. It is possible to port forward your printer and host this in AWS or off-premise.

- Install Git (only for windows)
- Install Docker
- Install Docker-Compose

### Step 1: env File

- Create an .env file.
- Add the Printer IP you configured when you setup your printer.
- Add the Printer Password from the Printer Network Settings Menu.
- Add the MQTT_TOPIC for your printer.

```env
# EXAMPLE .ENV FILE
BAMBU_PRINTER_IP=192.168.0.1
USERNAME=bblp
PASSWORD=12345678
MQTT_TOPIC=device/00M00A2B08124765/report
```

This can be tested using an MQTT application such as [MQTT Explorer](https://mqtt-explorer.com/).

- To connect, you must:
  - Enable (TLS).
  - Use the protocol `mqtt://`.
  - Set the port to 8883.
  - Set username `bblp`.
  - Set password.
    - For Bambu Labs A1, password is found under Settings -> LAN Only Mode -> Access Code.
    - Please note that you can regenerate a password on the device manually.
  - Select Advanced, remove all existing topics and add a new one like `device/[PrinterSerialNumber]/report`.
  - Click Connect.
- Collect the MQTT_TOPIC by expanding the "Device", "Serial Number", "Report". The result should look
  similar to `device/00M00A2B08124765/report`.

### Step 2: Clone the repo

```bash
git clone https://github.com/Aetrius/Bambulabs-Exporter.git
cd Bambulabs-Exporter
```

### Step 3: Run Docker Compose

> [!IMPORTANT]
> You will need to likely run an MQTT program to test your connection. You can pull the password
> from the printer interface manually, or reset it on the printer itself.

```bash
docker-compose -f docker/docker-compose-yaml up -d

# or with make
make compose-up
make compose-logs
```

## Bugs

- 3/4/2023 - Exporter loses connection during firmware upgrade or powercycle. (Temp solution to restart the docker container). Adding restart always to the docker-compose fixes this for now or throwing this into a kubernetes manifest works as it will restart to recover.

## Feature Changes

- 5/28/2023 - Added Healthz endpoint
- 3/31/2023 - Added support for passing env vars to the container instead of the .env file. This helps when using a docker-compose file to pass vars OR in a kubernetes manifest to pass the vars. More to come on documentation.
- 3/4/2023 - Added new Metrics `ams_humidity`, `ams_temp`, `ams_tray_color`, `ams_bed_temp`. These include ams number and tray numbers to be dynamic depending on how many AMS's are included. Will push new container to dockerhub later today 3/4/23
- 2/28/2023 - Initial Metrics released. Further re-work needed to account for all the useful metrics available.

## Future Development

- Add Kubernetes Configs
- Add Grafana Dashboard changes for AMS

## Credit

Give me a shout if you utilize this code base (Anywhere!).

## Support Questions

```text
tylerwbennet@gmail.com
```
