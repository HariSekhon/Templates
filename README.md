# Code & Config Templates

[![GitHub stars](https://img.shields.io/github/stars/HariSekhon/Templates?logo=github)](https://github.com/HariSekhon/Templates//stargazers)
[![GitHub forks](https://img.shields.io/github/forks/HariSekhon/Templates?logo=github)](https://github.com/HariSekhon/Templates/network)
[![Lines of Code](https://img.shields.io/badge/lines%20of%20code-9k-lightgrey?logo=codecademy)](https://github.com/HariSekhon/Templates)
[![License](https://img.shields.io/github/license/HariSekhon/Templates)](https://github.com/HariSekhon/Templates/blob/master/LICENSE)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/HariSekhon/Templates?logo=github)](https://github.com/HariSekhon/Templates/commits/master)

[![CI Builds Overview](https://img.shields.io/badge/CI%20Builds-Overview%20Page-blue?logo=circleci)](https://harisekhon.github.io/CI-CD/)
[![ShellCheck](https://github.com/HariSekhon/Templates/actions/workflows/shellcheck.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/shellcheck.yaml)
[![JSON](https://github.com/HariSekhon/Templates/actions/workflows/json.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/json.yaml)
[![YAML](https://github.com/HariSekhon/Templates/actions/workflows/yaml.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/yaml.yaml)
[![XML](https://github.com/HariSekhon/Templates/actions/workflows/xml.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/xml.yaml)
[![Validation](https://github.com/HariSekhon/Templates/actions/workflows/validate.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/validate.yaml)
[![Checkov](https://github.com/HariSekhon/Templates/actions/workflows/checkov.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/checkov.yaml)
[![Kics](https://github.com/HariSekhon/Templates/actions/workflows/kics.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/kics.yaml)
[![Grype](https://github.com/HariSekhon/Templates/actions/workflows/grype.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/grype.yaml)
[![Semgrep](https://github.com/HariSekhon/Templates/actions/workflows/semgrep.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/semgrep.yaml)
[![Semgrep Cloud](https://github.com/HariSekhon/Templates/actions/workflows/semgrep-cloud.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/semgrep-cloud.yaml)
[![Trivy](https://github.com/HariSekhon/Templates/actions/workflows/trivy.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/trivy.yaml)
[![Redhat Kickstart](https://github.com/HariSekhon/Templates/actions/workflows/kickstart.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/kickstart.yaml)
[![Debian Preseed](https://github.com/HariSekhon/Templates/actions/workflows/preseed.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/preseed.yaml)
[![Ubuntu AutoInstall Cloud-Init](https://github.com/HariSekhon/Templates/actions/workflows/autoinstall-user-data.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/autoinstall-user-data.yaml)
[![HashiCorp Packer](https://github.com/HariSekhon/Templates/actions/workflows/packer.yaml/badge.svg)](https://github.com/HariSekhon/Templates/actions/workflows/packer.yaml)

[![Repo on Azure DevOps](https://img.shields.io/badge/repo-Azure%20DevOps-0078D7?logo=azure%20devops)](https://dev.azure.com/harisekhon/GitHub/_git/Templates)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-2088FF?logo=github)](https://github.com/HariSekhon/Templates)
[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-FCA121?logo=gitlab)](https://gitlab.com/HariSekhon/Templates)
[![Repo on BitBucket](https://img.shields.io/badge/repo-BitBucket-0052CC?logo=bitbucket)](https://bitbucket.org/HariSekhon/Templates)

[git.io/code-templates](https://git.io/code-templates)

Code & DevOps Config templates for many popular programming languages and DevOps tools including:

- Kubernetes - advanced K8s templates eg.
[deployment.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/deployment.yaml),
[statefulset.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/statefulset.yaml),
[service.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/service.yaml),
[ingress.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/ingress.yaml), [kustomization.yaml](https://github.com/HariSekhon/Kubernetes-configs/blob/master/kustomization.yaml), [skaffold.yaml](https://github.com/HariSekhon/Templates/blob/master/skaffold.yaml), [helmfile.yaml](https://github.com/HariSekhon/Templates/blob/master/helmfile.yaml), [k3d.yaml](https://github.com/HariSekhon/Templates/blob/master/k3d.yaml), [kind.yaml](https://github.com/HariSekhon/Templates/blob/master/kind.yaml) and [many others](https://github.com/HariSekhon/Kubernetes-configs)
- Terraform -
[provider.tf](https://github.com/HariSekhon/Templates/blob/master/provider.tf),
[backend.tf](https://github.com/HariSekhon/Templates/blob/master/backend.tf),
[variables.tf](https://github.com/HariSekhon/Templates/blob/master/variables.tf),
[terraform.tfvars](https://github.com/HariSekhon/Templates/blob/master/terraform.tfvars) - see this [bundle trick](https://github.com/HariSekhon/Templates/#new-terraform)
- Docker - [Dockerfile](https://github.com/HariSekhon/Templates/blob/master/Dockerfile), [docker-compose.yml](https://github.com/HariSekhon/Templates/blob/master/docker-compose.yml)
- HashiCorp Packer - [template.pkr.hcl](https://github.com/HariSekhon/Templates/blob/master/template.pkr.hcl) - build portable Virtual Machines of Debian, Ubuntu and RHEL-based distros using 100% automated installs via Kickstart, Preseed, AutoInstaller. See [Packer-templates](https://github.com/HariSekhon/Packer-templates)
- AWS - various - `aws_*`, [buildspec.yml](https://github.com/HariSekhon/Templates/blob/master/buildspec.yml), `ec*`, [eksctl.yaml](https://github.com/HariSekhon/Templates/blob/master/eksctl.yaml), `lambda*`, `s3*`
- GCP - [cloudbuild.yaml](https://github.com/HariSekhon/Templates/blob/master/cloudbuild.yaml), [cloudbuild-golang.yaml](https://github.com/HariSekhon/Templates/blob/master/cloudbuild-golang.yaml), [gcp_deployment-manager.yaml](https://github.com/HariSekhon/Templates/blob/master/gcp_deployment_manager.yaml)
- Jenkins - [Jenkinsfile](https://github.com/HariSekhon/Jenkins/blob/master/Jenkinsfile) (advanced) and [jenkins/vars/](https://github.com/HariSekhon/Jenkins/tree/master/vars) Jenkins Shared Library
- GitHub Actions - [github-action.yaml](https://github.com/HariSekhon/GitHub-Actions/blob/master/main.yaml) (advanced) and [github-actions/.github/workflows](https://github.com/HariSekhon/GitHub-Actions/tree/master/.github/workflows) GitHub Workflows Library
- Azure DevOps Pipelines - [azure-pipelines.yaml](https://github.com/HariSekhon/Templates/blob/master/azure-pipelines.yml)
- Circle CI - [circleci-config.yml](https://github.com/HariSekhon/Templates/blob/master/circleci-config.yml) (advanced)
- Vagrant - [Vagrantfile](https://github.com/HariSekhon/Templates/blob/master/Vagrantfile)
- Make - [Makefile](https://github.com/HariSekhon/Templates/blob/master/Makefile)
- Maven - [pom.xml](https://github.com/HariSekhon/Templates/blob/master/pom.xml)
- SBT - [build.sbt](https://github.com/HariSekhon/Templates/blob/master/build.sbt)
- Gradle - [build.gradle](https://github.com/HariSekhon/Templates/blob/master/build.gradle)
- Golang - [template.go](https://github.com/HariSekhon/Templates/blob/master/template.go)
- Groovy - [template.groovy](https://github.com/HariSekhon/Templates/blob/master/template.groovy)
- Perl - [template.pl](https://github.com/HariSekhon/Templates/blob/master/template.pl), [template.pm](https://github.com/HariSekhon/Templates/blob/master/template.pm)
- Python / [Jython](https://www.jython.org/) - [template.py](https://github.com/HariSekhon/Templates/blob/master/template.py) / `template.jy`
- Ruby / [JRuby](https://www.jruby.org/) - [template.rb](https://github.com/HariSekhon/Templates/blob/master/template.rb), [template.jrb](https://github.com/HariSekhon/Templates/blob/master/template.jrb), [Gemfile](https://github.com/HariSekhon/Templates/blob/master/Gemfile)
- Scala - [template.scala](https://github.com/HariSekhon/Templates/blob/master/template.scala)
- Bash - [template.sh](https://github.com/HariSekhon/Templates/blob/master/template.sh)
- Puppet - [template.pp](https://github.com/HariSekhon/Templates/blob/master/template.pp)
- Redhat Kickstart automated install - [anaconda-ks.cfg](https://github.com/HariSekhon/Templates/blob/master/anaconda-ks.cfg)
- Debian Preseed automated install - [preseed.cfg](https://github.com/HariSekhon/Templates/blob/master/preseed.cfg)
- Ubuntu AutoInstall Cloud-Init - [autoinstall-user-data](https://github.com/HariSekhon/Templates/blob/master/autoinstall-user-data)
- MermaidJS - [template.mmd](https://raw.githubusercontent.com/HariSekhon/Templates/master/template.mmd)
- D2 Lang - [diagram.d2](https://github.com/HariSekhon/Templates/blob/master/diagram.d2)
- Python Diagrams - [diagram.py](https://github.com/HariSekhon/Templates/blob/master/diagram.py)
- SQL - [template.sql](https://github.com/HariSekhon/Templates/blob/master/template.sql)
- XML - [template.xml](https://github.com/HariSekhon/Templates/blob/master/template.xml)
- YAML - [template.yaml](https://github.com/HariSekhon/Templates/blob/master/template.yaml)

Many more real world DevOps Tooling & CI/CD configs for all major CI/CD systems can be found in the [DevOps Bash tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo.

Forked from [DevOps Perl tools](https://github.com/HariSekhon/DevOps-Perl-tools), this is now a submodule of the following repos:

- [DevOps Bash tools](https://github.com/HariSekhon/DevOps-Bash-tools)
- [DevOps Python tools](https://github.com/HariSekhon/DevOps-Python-tools)
- [DevOps Perl tools](https://github.com/HariSekhon/DevOps-Perl-tools)

### New

`new.pl` can instantiate these templates as new date-timestamped files, autopopulating the date, vim tags, GitHub URL and other headers and drops you in to your `$EDITOR` of choice (eg. `vim`).

You can give an exact filename like `Dockerfile`, `Makefile`, `Jenkinsfile`, `docker-compose.yml`, `pom.xml`, `build.gradle`, or you can instantiate one of the templates based on their file extension (eg. `py`, `sh`) with any filename (eg. `main.py`, `test.py`, `myapp.py`).

Examples:

```shell
new Makefile
```
```shell
new Dockerfile
```
```shell
new Jenkinsfile
```
```shell
new docker-compose.yml
```
```shell
new myapp.py
```
```shell
new build.gradle
```
```shell
new .github/workflows/build.yaml
```

`new.pl` can be found in the [DevOps Perl tools](https://github.com/HariSekhon/DevOps-Perl-tools) repo.

```alias new=new.pl```

(done automatically in the [DevOps Bash tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo `.bash.d/`)


### Terraform

`new terraform`

Instantly creates and opens all standard files for a Terraform deployment in your `$EDITOR` of choice:

- [provider.tf](https://github.com/HariSekhon/Terraform-templates/blob/master/provider.tf)
- [backend.tf](https://github.com/HariSekhon/Terraform-templates/blob/master/backend.tf)
- [variables.tf](https://github.com/HariSekhon/Terraform-templates/blob/master/variables.tf)
- [versions.tf](https://github.com/HariSekhon/Terraform-templates/blob/master/versions.tf)
- [terraform.tfvars](https://github.com/HariSekhon/Terraform-templates/blob/master/terraform.tfvars)
- [main.tf](https://github.com/HariSekhon/Terraform-templates/blob/master/main.tf)

all heavily commented to get a new Terraform environment up and running quickly - with links to things like AWS / GCP regions, Terraform backend providers, state locking etc.

```shell
new terraform
```
or shorter
```shell
new tf
```

### Packer

Creates portable Virtual Machines in OVA format using 100% automated installs of Ubuntu, Debian and RHEL/Fedora using their native installers:

- Packer - [template.pkr.hcl](https://github.com/HariSekhon/Templates/blob/master/template.pkr.hcl) - uses the following:
- Redhat Kickstart - [anaconda-ks.cfg](https://github.com/HariSekhon/Templates/blob/master/anaconda-ks.cfg)
- Debian Preseed - [preseed.cfg](https://github.com/HariSekhon/Templates/blob/master/preseed.cfg)
- Ubuntu AutoInstall - [autoinstall-user-data](https://github.com/HariSekhon/Templates/blob/master/autoinstall-user-data)

See [Packer-templates](https://github.com/HariSekhon/Packer-templates) for more details and ready-to-run templates for each distro.


## Related Repositories

- [Jenkins](https://github.com/HariSekhon/Jenkins) - Advanced Jenkinsfile & Jenkins Groovy Shared Library

- [GitHub-Actions](https://github.com/HariSekhon/GitHub-Actions) - GitHub Actions master template & GitHub Actions Shared Workflows library

- [DevOps Bash Tools](https://github.com/HariSekhon/DevOps-Bash-tools) - 1000+ DevOps Bash Scripts, Advanced `.bashrc`, `.vimrc`, `.screenrc`, `.tmux.conf`, `.gitconfig`, CI configs & Utility Code Library - AWS, GCP, Kubernetes, Docker, Kafka, Hadoop, SQL, BigQuery, Hive, Impala, PostgreSQL, MySQL, LDAP, DockerHub, Jenkins, Spotify API & MP3 tools, Git tricks, GitHub API, GitLab API, BitBucket API, Code & build linting, package management for Linux / Mac / Python / Perl / Ruby / NodeJS / Golang, and lots more random goodies

- [SQL Scripts](https://github.com/HariSekhon/SQL-scripts) - 100+ SQL Scripts - PostgreSQL, MySQL, AWS Athena, Google BigQuery

- [Kubernetes configs](https://github.com/HariSekhon/Kubernetes-configs) - Kubernetes YAML configs - Best Practices, Tips & Tricks are baked right into the templates for future deployments

- [Terraform](https://github.com/HariSekhon/Terraform) - Terraform templates for AWS / GCP / Azure / GitHub management

- [DevOps Python Tools](https://github.com/HariSekhon/DevOps-Python-tools) - 80+ DevOps CLI tools for AWS, GCP, Hadoop, HBase, Spark, Log Anonymizer, Ambari Blueprints, AWS CloudFormation, Linux, Docker, Spark Data Converters & Validators (Avro / Parquet / JSON / CSV / INI / XML / YAML), Elasticsearch, Solr, Travis CI, Pig, IPython

- [DevOps Perl Tools](https://github.com/harisekhon/perl-tools) - 25+ DevOps CLI tools for Hadoop, HDFS, Hive, Solr/SolrCloud CLI, Log Anonymizer, Nginx stats & HTTP(S) URL watchers for load balanced web farms, Dockerfiles & SQL ReCaser (MySQL, PostgreSQL, AWS Redshift, Snowflake, Apache Drill, Hive, Impala, Cassandra CQL, Microsoft SQL Server, Oracle, Couchbase N1QL, Dockerfiles, Pig Latin, Neo4j, InfluxDB), Ambari FreeIPA Kerberos, Datameer, Linux...

- [The Advanced Nagios Plugins Collection](https://github.com/HariSekhon/Nagios-Plugins) - 450+ programs for Nagios monitoring your Hadoop & NoSQL clusters. Covers every Hadoop vendor's management API and every major NoSQL technology (HBase, Cassandra, MongoDB, Elasticsearch, Solr, Riak, Redis etc.) as well as message queues (Kafka, RabbitMQ), continuous integration (Jenkins, Travis CI) and traditional infrastructure (SSL, Whois, DNS, Linux)

- [Nagios Plugin Kafka](https://github.com/HariSekhon/Nagios-Plugin-Kafka) - Kafka API pub/sub Nagios Plugin written in Scala with Kerberos support

- [HAProxy Configs](https://github.com/HariSekhon/HAProxy-configs) - 80+ HAProxy Configs for Hadoop, Big Data, NoSQL, Docker, Elasticsearch, SolrCloud, HBase, Cloudera, Hortonworks, MapR, MySQL, PostgreSQL, Apache Drill, Hive, Presto, Impala, ZooKeeper, OpenTSDB, InfluxDB, Prometheus, Kibana, Graphite, SSH, RabbitMQ, Redis, Riak, Rancher etc.

- [Dockerfiles](https://github.com/HariSekhon/Dockerfiles) - 50+ DockerHub public images for Docker & Kubernetes - Hadoop, Kafka, ZooKeeper, HBase, Cassandra, Solr, SolrCloud, Presto, Apache Drill, Nifi, Spark, Mesos, Consul, Riak, OpenTSDB, Jython, Advanced Nagios Plugins & DevOps Tools repos on Alpine, CentOS, Debian, Fedora, Ubuntu, Superset, H2O, Serf, Alluxio / Tachyon, FakeS3

- [HashiCorp Packer templates](https://github.com/HariSekhon/Packer-templates) - Linux automated bare-metal installs and portable virtual machines OVA format appliances using HashiCorp Packer, Redhat Kickstart, Debian Preseed and Ubuntu AutoInstaller / Cloud-Init

- [Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) - Cloud & Open Source architecture diagrams with Python & D2 source code provided - automatically regenerated via GitHub Actions CI/CD - AWS, GCP, Kubernetes, Jenkins, ArgoCD, Traefik, Kong API Gateway, Nginx, Redis, PostgreSQL, Kafka, Spark, web farms, event processing...

[![Stargazers over time](https://starchart.cc/HariSekhon/Templates.svg)](https://starchart.cc/HariSekhon/Templates)

[git.io/code-templates](https://git.io/code-templates)
