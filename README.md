# Kubectl Plugin

## Introduction
kubectl-dump is kubectl plugin to thread dump java application in kubernetes pod.

## Installation

move the kubectl-dump to your binary executable dir, like `/bin` or `/usr/local/bin` without the extension name.

```
mv kubectl-dump.sh /usr/local/bin/kubectl-dump
```

## Usage

```
kubectl Thread Dump help
    -p, --pod: set the pod name
    -n, --namespace: set the namespace name (optional)
    -f, --file: write thread dump log to file (optional)
```

to thread dump pod:

```
kubectl-dump -p java-app-56487fbfd5-785xv
```

the output will be:

```
metadata
    container: java-app-56487fbfd5-785xv
    namespace: production
    output file: false

2020-03-28 15:32:15
Full thread dump OpenJDK 64-Bit Server VM (25.212-b04 mixed mode):

"PostgreSQL-JDBC-SharedTimer-89" #1028 daemon prio=5 os_prio=0 tid=0x000055e29b509800 nid=0x4e2 in Object.wait() [0x00007f59ad89f000]
   java.lang.Thread.State: WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        at java.lang.Object.wait(Object.java:502)
        at java.util.TimerThread.mainLoop(Timer.java:526)
        - locked <0x00000006ee6b6540> (a java.util.TaskQueue)
        at java.util.TimerThread.run(Timer.java:505)

"WebSocket background processing" #707 daemon prio=5 os_prio=0 tid=0x000055e299f33000 nid=0x2ca waiting on condition [0x00007f59ae0a1000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
        at java.lang.Thread.sleep(Native Method)
        at org.apache.tomcat.websocket.BackgroundProcessManager$WsBackgroundThread.run(BackgroundProcessManager.java:136)
```

if you set write to file the file name will be `POD_NAME.log`.
