# Monitoring HyperNode status

The default monitoring port is 8899. Visit P:8899/metrics to get the status of Prometheus metrics.
Here is the Grafana dashboard file of HyperNode:
https://github.com/qinyh1990/csharpnet/blob/main/testnet/tasks/BP-02-001/HyperNode.json
## Grafana Download

https://grafana.com/grafana/download?pg=get&plcmt=selfmanaged-box1-cta1

### Promthues Download

https://github.com/prometheus/prometheus/releases



### Promthues configurations

The class: HyperNodeis related to the class="HyperNode" in Alertmanager. They should be kept the same. 

```bash
- labels:
    class: HyperNode
    name: aws-hypernode-1
    region: Tokyo
    service_provider: aws
  targets:
  - ip:8899
```

![image](https://user-images.githubusercontent.com/45475895/175547944-b9bf44f2-818d-4908-91b0-37d2e3af1c06.png)


### Alertmanager alert rule configurations

Explain what these tests test and why

```
groups:
  - name: HyperNode-node-alert
    rules:
    - alert: HyperNode-node-down
      expr: up{class="HyperNode"} == 0
      for: 1m
      labels:
        severity: warn
      annotations: 
        summary: "HyperNode not responding"  
        description: "- instance: {{ $labels.instance }} \n- name: {{ $labels.name }} HyperNode keeps not responding more than 1 min" 
        value: "{{ $value }}"
        instance: "{{ $labels.instance }}"
        id: "{{ $labels.instanceid }}"
```

# Monitoring system status

The Prometheus Node Exporter is used as the monitor system. Configured with Grafana dashboard, it is able to record the statue history of CPU, RAM, hard disc, and the network. 
Here is the Grafana dashboard developed by the community: https://grafana.com/grafana/dashboards/1860

![image](https://user-images.githubusercontent.com/45475895/175549641-19287aad-476c-4c9e-afef-f1c463fc313d.png)

## node_exporter Download

https://prometheus.io/download/#node_exporter


