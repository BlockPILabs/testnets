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

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
