Code & Config Templates
=======================

[![Travis CI](https://img.shields.io/travis/harisekhon/templates/master?logo=travis&label=Travis%20CI)](https://travis-ci.org/HariSekhon/Templates)
[![CI Builds Overview](https://img.shields.io/badge/CI%20Builds-Overview%20Page-blue?logo=circleci)](https://bitbucket.org/harisekhon/devops-bash-tools/src/master/STATUS.md)
[![Repo on Azure DevOps](https://img.shields.io/badge/repo-Azure%20DevOps-0078D7?logo=azure%20devops)](https://dev.azure.com/harisekhon/GitHub/_git/Templates)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-2088FF?logo=github)](https://github.com/HariSekhon/Templates)
[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-FCA121?logo=gitlab)](https://gitlab.com/HariSekhon/Templates)
[![Repo on BitBucket](https://img.shields.io/badge/repo-BitBucket-0052CC?logo=bitbucket)](https://bitbucket.org/HariSekhon/Templates)
[![Lines of Code](https://img.shields.io/badge/lines%20of%20code-5k-lightgrey?logo=codecademy)](https://github.com/HariSekhon/Templates)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/HariSekhon/Templates?logo=github)](https://github.com/HariSekhon/Templates/commits/master)

[git.io/code-templates](https://git.io/code-templates)

Code & DevOps Config templates for many popular programming languages and DevOps tools including:

- [Kubernetes](https://kubernetes.io/) - templates for every major k8s object eg.
[deployment.yaml](https://github.com/HariSekhon/Kubernetes-templates/blob/master/deployment.yaml),
[statefulset.yaml](https://github.com/HariSekhon/Kubernetes-templates/blob/master/statefulset.yaml),
[service.yaml](https://github.com/HariSekhon/Kubernetes-templates/blob/master/service.yaml),
[ingress.yaml](https://github.com/HariSekhon/Kubernetes-templates/blob/master/ingress.yaml), [kustomization.yml](https://github.com/HariSekhon/Kubernetes-templates/blob/master/kustomization.yaml) and [many others](https://github.com/HariSekhon/Kubernetes-templates)
- [Terraform](https://www.terraform.io/) -
[provider.tf](https://github.com/HariSekhon/Templates/blob/master/provider.tf),
[backend.tf](https://github.com/HariSekhon/Templates/blob/master/backend.tf),
[variables.tf](https://github.com/HariSekhon/Templates/blob/master/variables.tf),
[terraform.tfvars](https://github.com/HariSekhon/Templates/blob/master/terraform.tfvars) - see this [bundle trick](https://github.com/HariSekhon/Templates/#new-terraform)
- [Docker](https://www.docker.com/) - [Dockerfile](https://github.com/HariSekhon/Templates/blob/master/Dockerfile), [docker-compose.yml](https://github.com/HariSekhon/Templates/blob/master/docker-compose.yml)
- [AWS](https://aws.amazon.com/) - various templates
- [GCP](https://cloud.google.com/) - [cloudbuild.yaml](https://github.com/HariSekhon/Templates/blob/master/cloudbuild.yaml), [cloudbuild-golang.yaml](https://github.com/HariSekhon/Templates/blob/master/cloudbuild-golang.yaml), [gcp_deployment-manager.yaml](https://github.com/HariSekhon/Templates/blob/master/gcp_deployment_manager.yaml)
- [Jenkins](https://www.jenkins.io/) - [Jenkinsfile](https://github.com/HariSekhon/Templates/blob/master/Jenkinsfile)
- [Vagrant](https://www.vagrantup.com/) - [Vagrantfile](https://github.com/HariSekhon/Templates/blob/master/Vagrantfile)
- [Make](https://www.gnu.org/software/make/) - [Makefile](https://github.com/HariSekhon/Templates/blob/master/Makefile)
- [Maven](https://maven.apache.org/) - [pom.xml](https://github.com/HariSekhon/Templates/blob/master/pom.xml)
- [SBT](https://www.scala-sbt.org/) - [build.sbt](https://github.com/HariSekhon/Templates/blob/master/build.sbt)
- [Gradle](https://gradle.org/) - [build.gradle](https://github.com/HariSekhon/Templates/blob/master/build.gradle)
- [Golang](https://golang.org/) - [template.go](https://github.com/HariSekhon/Templates/blob/master/template.go)
- [Groovy](https://groovy-lang.org/) - [template.groovy](https://github.com/HariSekhon/Templates/blob/master/template.groovy)
- [Perl](https://www.perl.org/) - [template.pl](https://github.com/HariSekhon/Templates/blob/master/template.pl), [template.pm](https://github.com/HariSekhon/Templates/blob/master/template.pm)
- [Python](https://www.python.org/) / [Jython](https://www.jython.org/) - [template.py](https://github.com/HariSekhon/Templates/blob/master/template.py) / `template.jy`
- [Ruby](https://www.ruby-lang.org/en/) / [JRuby](https://www.jruby.org/) - [template.rb](https://github.com/HariSekhon/Templates/blob/master/template.rb), [template.jrb](https://github.com/HariSekhon/Templates/blob/master/template.jrb)
- [Scala](https://www.scala-lang.org/) - [template.scala](https://github.com/HariSekhon/Templates/blob/master/template.scala)
- [Bash](https://www.gnu.org/software/bash/) - [template.sh](https://github.com/HariSekhon/Templates/blob/master/template.sh)
- [Puppet](https://puppet.com/) - [template.pp](https://github.com/HariSekhon/Templates/blob/master/template.pp)
- [Circle CI](https://circleci.com/) - [circleci_config.yml](https://github.com/HariSekhon/Templates/blob/master/circleci_config.yml)
- SQL - [template.sql](https://github.com/HariSekhon/Templates/blob/master/template.sql)
- XML - [template.xml](https://github.com/HariSekhon/Templates/blob/master/template.xml)
- YAML - [template.yaml](https://github.com/HariSekhon/Templates/blob/master/template.yaml)

Forked from [DevOps Perl tools](https://github.com/HariSekhon/DevOps-Perl-tools) repo for which this is now a submodule.

### New

`new.pl` can instantiate these templates as new date-timestamped files, autopopulating the date, vim tags, GitHub URL and other headers and drops you in to your `$EDITOR` of choice (eg. `vim`).

You can give an exact filename like `Dockerfile`, `Makefile`, `Jenkinsfile`, `docker-compose.yml`, `pom.xml`, `build.gradle`, or you can instantiate one of the templates based on their file extension (eg. `py`, `sh`) with any filename (eg. `main.py`, `test.py`, `myapp.py`).

Examples:

```
new Dockerfile
```
```
new Jenkinsfile
```
```
new docker-compose.yml
```
```
new myapp.py
```
```
new build.gradle
```

`new.pl` can be found in the [DevOps Perl tools](https://github.com/HariSekhon/DevOps-Perl-tools) repo.

```alias new=new.pl```

(done automatically in the [DevOps Bash tools](https://github.com/HariSekhon/DevOps-Bash-tools) repo `.bash.d/`)


#### New Terraform

Instantly creates and opens all standard files for a Terraform deployment in your `$EDITOR` of choice:

- [provider.tf](https://github.com/HariSekhon/Templates/blob/master/provider.tf)
- [backend.tf](https://github.com/HariSekhon/Templates/blob/master/backend.tf)
- [variables.tf](https://github.com/HariSekhon/Templates/blob/master/variables.tf)
- [terraform.tfvars](https://github.com/HariSekhon/Templates/blob/master/terraform.tfvars)
- `main.tf`

all heavily commented to get a new Terraform environment up and running quickly - with links to things like AWS / GCP regions, Terraform backend providers, state locking etc.

```
new terraform
```
or shorter
```
new tf
```


### See Also:

* [DevOps Bash Tools](https://github.com/harisekhon/devops-bash-tools) - 550+ DevOps Bash Scripts, Advanced `.bashrc`, `.vimrc`, `.screenrc`, `.tmux.conf`, `.gitconfig`, CI configs & Utility Code Library - AWS, GCP, Kubernetes, Docker, Kafka, Hadoop, SQL, BigQuery, Hive, Impala, PostgreSQL, MySQL, LDAP, DockerHub, Jenkins, Spotify API & MP3 tools, Git tricks, GitHub API, GitLab API, BitBucket API, Code & build linting, package management for Linux / Mac / Python / Perl / Ruby / NodeJS / Golang, and lots more random goodies

* [SQL Scripts](https://github.com/HariSekhon/SQL-scripts) - 100+ SQL Scripts - PostgreSQL, MySQL, AWS Athena, Google BigQuery

* [Kubernetes templates](https://github.com/HariSekhon/Kubernetes-templates) - Kubernetes YAML templates - Best Practices, Tips & Tricks are baked right into the templates for future deployments

* [DevOps Python Tools](https://github.com/harisekhon/devops-python-tools) - 80+ DevOps CLI tools for AWS, Hadoop, HBase, Spark, Log Anonymizer, Ambari Blueprints, AWS CloudFormation, Linux, Docker, Spark Data Converters & Validators (Avro / Parquet / JSON / CSV / INI / XML / YAML), Elasticsearch, Solr, Travis CI, Pig, IPython

* [The Advanced Nagios Plugins Collection](https://github.com/harisekhon/nagios-plugins) - 450+ programs for Nagios monitoring your Hadoop & NoSQL clusters. Covers every Hadoop vendor's management API and every major NoSQL technology (HBase, Cassandra, MongoDB, Elasticsearch, Solr, Riak, Redis etc.) as well as message queues (Kafka, RabbitMQ), continuous integration (Jenkins, Travis CI) and traditional infrastructure (SSL, Whois, DNS, Linux)

* [DevOps Perl Tools](https://github.com/harisekhon/perl-tools) - 25+ DevOps CLI tools for Hadoop, HDFS, Hive, Solr/SolrCloud CLI, Log Anonymizer, Nginx stats & HTTP(S) URL watchers for load balanced web farms, Dockerfiles & SQL ReCaser (MySQL, PostgreSQL, AWS Redshift, Snowflake, Apache Drill, Hive, Impala, Cassandra CQL, Microsoft SQL Server, Oracle, Couchbase N1QL, Dockerfiles, Pig Latin, Neo4j, InfluxDB), Ambari FreeIPA Kerberos, Datameer, Linux...

* [HAProxy Configs](https://github.com/HariSekhon/HAProxy-configs) - 80+ HAProxy Configs for Hadoop, Big Data, NoSQL, Docker, Elasticsearch, SolrCloud, HBase, Cloudera, Hortonworks, MapR, MySQL, PostgreSQL, Apache Drill, Hive, Presto, Impala, ZooKeeper, OpenTSDB, InfluxDB, Prometheus, Kibana, Graphite, SSH, RabbitMQ, Redis, Riak, Rancher etc.

* [Dockerfiles](https://github.com/HariSekhon/Dockerfiles) - 50+ DockerHub public images for Docker & Kubernetes - Hadoop, Kafka, ZooKeeper, HBase, Cassandra, Solr, SolrCloud, Presto, Apache Drill, Nifi, Spark, Mesos, Consul, Riak, OpenTSDB, Jython, Advanced Nagios Plugins & DevOps Tools repos on Alpine, CentOS, Debian, Fedora, Ubuntu, Superset, H2O, Serf, Alluxio / Tachyon, FakeS3

[![Stargazers over time](https://starchart.cc/HariSekhon/Templates.svg)](https://starchart.cc/HariSekhon/Templates)

[git.io/code-templates](https://git.io/code-templates)
