# TensorFlow.js

**Ubuntu and CentOS only**

Go to the Shinobi directory. **/home/Shinobi** is the default directory.

```
cd /home/Shinobi/plugins/tensorflow
```

Copy the config file.

- To run the install script interactively:
```
sh INSTALL.sh
```
- To run the install script non-interactively:

```
sh INSTALL.sh
```
*WITH* the appropriate flags

| Flag      | Purpose |
| ----------- | ----------- |
| `--jetson`| Install for Jetson Nano|
| `--arm`| Install for ARM Processors (like Raspberry Pi Model 3 B+)|
| `--gpu`| Install for GPU support|
| `--dont-create-key`| Don't generate random plugin key|

Start the plugin.

```
pm2 start shinobi-tensorflow.js
```

Doing this will reveal options in the monitor configuration. Shinobi does not need to be restarted when a plugin is initiated or stopped.

## Run the plugin as a Host
> The main app (Shinobi) will be the client and the plugin will be the host. The purpose of allowing this method is so that you can use one plugin for multiple Shinobi instances. Allowing you to easily manage connections without starting multiple processes.

Edit your plugins configuration file. Set the `hostPort` **to be different** than the `listening port for camera.js`.

```
nano conf.json
```

Here is a sample of a Host configuration for the plugin.
 - `plug` is the name of the plugin corresponding in the main configuration file.
 - `https` choose if you want to use SSL or not. Default is `false`.
 - `hostPort` can be any available port number. **Don't make this the same port number as Shinobi.** Default is `8082`.
 - `type` tells the main application (Shinobi) what kind of plugin it is. In this case it is a detector.

```
{
  "plug":"Tensorflow",
  "hostPort":8082,
  "key":"Tensorflow123123",
  "mode":"host",
  "type":"detector"
}
```

Now modify the **main configuration file** located in the main directory of Shinobi.

```
nano conf.json
```

Add the `plugins` array if you don't already have it. Add the following *object inside the array*.

```
  "plugins":[
      {
          "id" : "Tensorflow",
          "https" : false,
          "host" : "localhost",
          "port" : 8082,
          "key" : "Tensorflow123123",
          "mode" : "host",
          "type" : "detector"
      }
  ],
```

# Docker Installation
> Install Shinobi Plugin with Docker

> Image is based on `node:12.22.1-buster-slim`.

1. Enter plugin directory. Default Shinobi installation location is `/home/Shinobi`.

```
cd /home/Shinobi/plugins/tensorflow
```

2. Build Image.

```
docker build --tag shinobi-tensorflow-image:1.0 .
```

3. Launch the plugin.

- `-e ADD_CONFIG='{"key":"123mypluginkey","tfjsBuild":"gpu","host":"172.16.100.238","port":"8080"}'` Adds any configuration parameters to the plugin's conf.json file.
- `-p '8082:8082/tcp'` is an optional flag if you decide to run the plugin in host mode.

```
docker run -d --gpus all --name='shinobi-tensorflow' -e ADD_CONFIG='{"key":"123mypluginkey","tfjsBuild":"gpu","host":"172.16.100.238","port":"8080"}' shinobi-tensorflow-image:1.0
```

** Logs **

```
docker logs /shinobi-tensorflow
```

** Stop and Remove **

```
docker stop /shinobi-tensorflow && docker rm /shinobi-tensorflow
```

### Options (Environment Variables)

| Option           | Description                                                                                                                                                                                               | Default    |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| ADD_CONFIG      | The plugin's name.                                                                                                                                                                                        | Tensorflow |
