# raspbian_sinatra_api
## Install as a systemctl service
### 1. Create a service file
  ```
  sudo nano /lib/systemd/system/raspbian_sinatra_api.service
  ```

### 2. Paste this lines inside the file and save
```
[Unit]
Description=Sinatra Server API
After=network.target

[Service]
ExecStart=/usr/bin/ruby /home/pi/raspbian_sinatra_api/server.rb

[Install]
WantedBy=multi-user.target
```

### 3. Reload systemctl
```
sudo systemctl daemon-reload
```
### 4. Enable service
```
sudo systemctl enable sinatra-api.service
```
### 5. Start service
```
sudo systemctl start sinatra-api.service
```

### 6. To know status of the service run
```
systemctl status sinatra-api.service
```
The ouput of this file should be something similar to this

```
sinatra-api.service - Sinatra Server API
   Loaded: loaded (/lib/systemd/system/sinatra-api.service; disabled; vendor preset: enabled)
   Active: active (running) since Fri 2018-03-16 19:17:35 UTC; 9min ago
 Main PID: 1951 (ruby)
   CGroup: /system.slice/sinatra-api.service
           └─1951 /usr/bin/ruby /home/pi/raspbian_sinatra_api/server.rb

Mar 16 19:17:35 raspberrypi systemd[1]: Started Sinatra Server API.
Mar 16 19:17:38 raspberrypi ruby[1951]: [2018-03-16 19:17:38] INFO  WEBrick 1.3.1
Mar 16 19:17:38 raspberrypi ruby[1951]: [2018-03-16 19:17:38] INFO  ruby 2.3.3 (2016-11-21) [arm-linux-gnueabihf]
Mar 16 19:17:38 raspberrypi ruby[1951]: == Sinatra (v2.0.1) has taken the stage on 4567 for development with backup from WEBrick
Mar 16 19:17:38 raspberrypi ruby[1951]: [2018-03-16 19:17:38] INFO  WEBrick::HTTPServer#start: pid=1951 port=4567
```
