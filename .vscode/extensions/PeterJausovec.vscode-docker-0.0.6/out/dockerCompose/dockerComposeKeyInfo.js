/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
"use strict";
// https://docs.docker.com/compose/yml/
exports.DOCKER_COMPOSE_KEY_INFO = {
    'image': ("Tag or partial image ID. Can be local or remote - Compose will attempt to pull if it doesn't exist locally."),
    'build': ("Path to a directory containing a Dockerfile. When the value supplied is a relative path, it is interpreted as relative to the " +
        "location of the yml file itself. This directory is also the build context that is sent to the Docker daemon.\n\n" +
        "Compose will build and tag it with a generated name, and use that image thereafter."),
    'command': ("Override the default command."),
    'links': ("Link to containers in another service. Either specify both the service name and the link alias (`CONTAINER:ALIAS`), or " +
        "just the service name (which will also be used for the alias)."),
    'external_links': ("Link to containers started outside this `docker-compose.yml` or even outside of Compose, especially for containers that " +
        "provide shared or common services. `external_links` follow " +
        "semantics similar to `links` when specifying both the container name and the link alias (`CONTAINER:ALIAS`)."),
    'ports': ("Expose ports. Either specify both ports (`HOST:CONTAINER`), or just the container port (a random host port will be chosen).\n\n" +
        "**Note**: When mapping ports in the `HOST:CONTAINER` format, you may experience erroneous results when using a container port " +
        "lower than 60, because YAML will parse numbers in the format `xx:yy` as sexagesimal (base 60). For this reason, we recommend " +
        "always explicitly specifying your port mappings as strings."),
    'expose': ("Expose ports without publishing them to the host machine - they'll only be accessible to linked services. \n" +
        "Only the internal port can be specified."),
    'volumes': ("Mount paths as volumes, optionally specifying a path on the host machine (`HOST:CONTAINER`), or an access mode (`HOST:CONTAINER:ro`)."),
    'volumes_from': ("Mount all of the volumes from another service or container."),
    'environment': ("Add environment variables. You can use either an array or a dictionary.\n\n" +
        "Environment variables with only a key are resolved to their values on the machine Compose is running on, which can be helpful for secret or host-specific values."),
    'env_file': ("Add environment variables from a file. Can be a single value or a list.\n\n" +
        "If you have specified a Compose file with `docker-compose -f FILE`, paths in `env_file` are relative to the directory that file is in.\n\n" +
        "Environment variables specified in `environment` override these values."),
    'net': ("Networking mode. Use the same values as the docker client `--net` parameter."),
    'pid': ("Sets the PID mode to the host PID mode. This turns on sharing between container and the host operating system the PID address space. " +
        "Containers launched with this flag will be able to access and manipulate other containers in the bare-metal machine's namespace and vise-versa."),
    'dns': ("Custom DNS servers. Can be a single value or a list."),
    'cap_add': ("Add or drop container capabilities. See `man 7 capabilities` for a full list."),
    'cap_drop': ("Add or drop container capabilities. See `man 7 capabilities` for a full list."),
    'dns_search': ("Custom DNS search domains. Can be a single value or a list."),
    'cgroup_parent': ("Specify an optional parent cgroup for the container."),
    'container_name': ("Specify custom container name, rather than a generated default name."),
    'devices': ("List of device mappings. Uses the same format as the `--device` docker client create option."),
    'dockerfile': ("Alternate dockerfile. Compose will use an alternate file to build with. Using `dockerfile` together with `image` is not allowed. Attempting to do so results in an error."),
    'extends': ("Extend another service, in the current file or another, optionally overriding configuration.\nYou can use `extends` on any service together with other configuration keys. " +
        "The `extends` value must be a dictionary defined with a required `service` and an optional `file` key."),
    'extra_hosts': ("Add hostname mappings. Use the same values as the docker client `--add-host` parameter."),
    'labels': ("Add metadata to containers using Docker labels. You can either use an array or a dictionary.\n" +
        "It's recommended that you use reverse-DNS notation to prevent your labels from conflicting with those used by other software."),
    'log_driver': ("Specify a logging driver for the service's containers, as with the `--log-driver` option for docker run. The default value is json-file."),
    'log_opt': ("Specify logging options with `log_opt` for the logging driver, as with the `--log-opt` option for docker run."),
    'security_opt': ("Override the default labeling scheme for each container."),
    'volume_driver': ("If you use a volume name (instead of a volume path), you may also specify a `volume_driver`.")
};
//# sourceMappingURL=dockerComposeKeyInfo.js.map