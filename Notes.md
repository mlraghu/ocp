
PAS to OCP

For OpenShift Container Platform
* 4 physical CPU cores
* 10.5 GB of free memory - 20 GB
* 35 GB of storage space - 60 GB

Prerequisites
Docker
Homebrew

I. Download local version of the OCP.  You will need redhat account.
Once you install you will use crc https://crc.dev/docs/using/

https://www.redhat.com/en/blog/install-openshift-local

$ crc config set preset OpenShift # Configure to use openshift preset

$crc config set disk-size 80 
$crc config set memory 20480 
$crc config set cpus 4   

$crc config view

- consent-telemetry          : no
- cpus                                 : 8
- disk-size                          : 80
- memory                            : 20480

$ crc setup # Initialize environment for cluster
$ crc start # Start the cluster


The server is accessible via web console at:
  https://console-openshift-console.apps-crc.testing

The server is accessible via web console at:
  https://console-openshift-console.apps-crc.testing

Log in as administrator:
  Username: kubeadmin
  Password: qcCSt-7hrzN-cUzUV-pnrkj

Log in as user:
  Username: developer
  Password: developer

Use the 'oc' command line interface:
  $ eval $(crc oc-env)
  $ oc login -u developer https://api.crc.testing:6443


$ oc config use-context crc-admin
$oc registry login --insecure=true


Add certain to trusted so docker does not complain pushing images
https://blog.container-solutions.com/adding-self-signed-registry-certs-docker-mac

$sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain occa.crt

Have docker login to OCP internal registry
docker login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing

Run move2kube plan and then transform to covert confidential with openshift target
Add necessary application configs to yaml files

Build and push images using the shell files in script folder

oc apply -f deploy/yamls --namespace=enterprise-app --overwrite


ON routes
https://www.youtube.com/watch?v=Vo8XmDNCZKE


ENTERPRISE_APP_CUSTOMERS_URL
ENTERPRISE_APP_INVENTORY_URL
ENTERPRISE_APP_ORDERS_URL




Copy to clipboard
