#!/bin/sh
set -eo pipefail

FILESET="false"

[ $# -eq 0 ] && {
    echo "Please fill requirement arguments."
    exit 1
}

options=$(getopt -o p:n:h::f:: --long pod:namespace:help::file:: -- "$@")
[ $? -eq 0 ] || {
    echo "Invalid arguments"
    exit 1
}
eval set -- "$options"

while true; do
    case "$1" in
    -p | --pod)
        shift
        POD=$1
        ;;
    -n | --namespace)
        shift
        NAMESPACE=$1
        ;;
    -f | --file)
        FILESET="true"
        ;;
    -h | --help)
        echo "kubectl Thread Dump help"
        echo "    -p, --pod: set the pod name"
        echo "    -n, --namespace: set the namespace name (optional)"
        echo "    -f, --file: write thread dump log to file (optional)"
        exit 0
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ -z "$POD" ]; then
    echo "POD is not set!"
    exit 1
fi

if [ -n "$POD" ] && [ -z "$NAMESPACE" ]; then
    NAMESPACE=$(kubectl get pod --all-namespaces | grep $POD | awk '{print $1}')
fi

echo "metadata"
echo "    container: $POD"
echo "    namespace: $NAMESPACE"
echo "    output file: $FILESET"
echo ""

PID=$(kubectl exec -it $POD -n $NAMESPACE -- /bin/sh -c "ps aux | grep java |head -1| awk '{print \$1}'" | tr -d '[:space:]')
kubectl exec -it $POD -n $NAMESPACE -- /bin/sh -c "kill -3 $PID"

if [ $FILESET == "true" ]; then
    kubectl logs $POD -n $NAMESPACE --since 1s > ${POD}.log
else
    kubectl logs $POD -n $NAMESPACE --since 1s
fi
