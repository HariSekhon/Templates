#!/usr/bin/env python
#  coding=utf-8
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: [% DATE  # 2023-04-14 13:54:52 +0100 (Fri, 14 Apr 2023) %]
#
#  https://github.com/HariSekhon/Templates
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn
#  and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

"""

Diagrams-as-Code Template

"""

__author__ = 'Hari Sekhon'
__version__ = '0.1'

# Diagram reference objects:
#
#   # 'onprem' includes Cloud SaaS CI/CD and major Open Source products including:
#   #
#   # - VCS - Git, GitHub, GitLab, Subversion (Svn)
#   # - CI/CD - Jenkins, ArgoCD, GitHub Actions, GitLab CI, CircleCI, Concourse, TeamCity, Tekton, Spinnaker
#   # - Databases - MySQL, PostgreSQL, Cassandra, HBase, MongoDB, Oracle, Couchbase, Neo4J, InfluxDB
#   # - Docker, Redis, Terraform, Vault, Ansible, Puppet, AWX, Atlantis
#   # - Apache httpd, Nginx, Kong, Traefik, HAProxy, Consul, Etcd
#   # - Analytics - Spark, Databricks, Kafka, Dbt, Flink, Hadoop, Hive, Presto, ZooKeeper, Storm, Airflow, Tableau
#   # - Queues - Kafka, RabbitMQ, ActiveMQ, Celery
#   # - Monitoring - Prometheus, Grafana, Datadog, Thanos, Splunk, Nagios
#   # - K8s ecosystem - Prometheus, ArgoCD, FluxCD, Fluentd, Etcd, Cert Manager, Lets Encrypt
#
#   https://diagrams.mingrammer.com/docs/nodes/onprem
#
#   https://diagrams.mingrammer.com/docs/nodes/aws
#
#   https://diagrams.mingrammer.com/docs/nodes/gcp
#
#   https://diagrams.mingrammer.com/docs/nodes/azure
#
#   https://diagrams.mingrammer.com/docs/nodes/k8s
#
#   https://diagrams.mingrammer.com/docs/nodes/elastic
#
#   https://diagrams.mingrammer.com/docs/nodes/generic
#
#   https://diagrams.mingrammer.com/docs/nodes/programming

# pylint: disable=E0401
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

# diagram name results in 'web_service.png' as the output name
# pylint: disable=W0106
with Diagram("Web Service", show=False):
    ELB("lb") >> EC2("web") >> RDS("userdb")
