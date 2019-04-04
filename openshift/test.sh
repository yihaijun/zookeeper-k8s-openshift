oc login -u yhj -pyhj
oc delete all,statefulset,pvc -l zk-name=myzk
oc delete -f openshift/buildconfig.yaml
oc delete bc zk-builder

docker rmi docker-registry.default.svc:5000/asip30/zookeeper:3.4.14
oc delete imagestream.image.openshift.io/zookeeper

oc create -f openshift/buildconfig.yaml
oc new-app zk-builder -p  IMAGE_STREAM_VERSION="3.4.14"  
oc logs -f bc/zk-builder

oc delete -f openshift/zk-persistent.yaml
oc delete  svc myzk
oc delete po  myzk-0 myzk-1 myzk-2
oc delete  services myzk
oc delete statefulset myzk
oc delete route.route.openshift.io/myzk
oc delete  pvc  datadir-myzk-0  datadir-myzk-1   datadir-myzk-2  datalogdir-myzk-0 datalogdir-myzk-1 datalogdir-myzk-2
oc delete pv pvtest1 pvtest2 pvtest3 pvtest4 pvtest5 pvtest6 pvtest7 pvtest8
oc get pv
showmount -d 172.16.30.98
oc create -f openshift/pvtest/pvtest1.yaml
oc create -f openshift/pvtest/pvtest2.yaml
oc create -f openshift/pvtest/pvtest3.yaml
oc create -f openshift/pvtest/pvtest4.yaml
oc create -f openshift/pvtest/pvtest5.yaml
oc create -f openshift/pvtest/pvtest6.yaml
oc create -f openshift/pvtest/pvtest7.yaml
oc create -f openshift/pvtest/pvtest8.yaml

oc get pv
oc get pvc

oc create -f openshift/zk-persistent.yaml

oc new-app zk-persistent -p NAME=myzk -p SOURCE_IMAGE="docker-registry.default.svc:5000/asip30/zookeeper"
oc expose svc/myzk
oc get all,pvc,statefulset -l zk-name=myzk

oc describe persistentvolumeclaim/datadir-myzk-0

showmount -d 172.16.30.98
oc get pv
oc get pvc 
oc get pods