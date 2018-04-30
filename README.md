[![Build Status](https://travis-ci.org/ckyvra/docker-maltrail.svg?branch=master)](https://travis-ci.org/ckyvra/docker-maltrail)

# Docker for maltrail

[Maltrail](https://github.com/stamparm/maltrail), Malicious traffic detection system, is composed of two python scripts,
the sensor and the server. We split these components into two different `Dockerfiles`, *maltrail-sensor* and *maltrail-server*, and run them via `docker-compose`.
