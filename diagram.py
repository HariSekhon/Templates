#!/usr/bin/env python3
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
#   https://diagrams.mingrammer.com/docs/nodes/saas  # contains Snowflake, Newrelic, Akamai, Cloudflare, Fastly, Slack, Teams, Auth0, Okta, DataDog, Facebook, Twitter
#
#   https://diagrams.mingrammer.com/docs/nodes/generic
#
#   https://diagrams.mingrammer.com/docs/nodes/programming

# pylint: disable=E0401

from diagrams import Diagram

# aws resources
from diagrams.aws.compute import ECS, Lambda
from diagrams.aws.database import RDS, ElastiCache
from diagrams.aws.network import ELB, Route53, VPC

# azure resources
from diagrams.azure.compute import FunctionApps
from diagrams.azure.storage import BlobStorage

# gcp resources
from diagrams.gcp.compute import AppEngine, GKE
from diagrams.gcp.ml import AutoML

# k8s resources
from diagrams.k8s.compute import Pod, StatefulSet
from diagrams.k8s.network import Service
from diagrams.k8s.storage import PV, PVC, StorageClass

# diagram name results in 'web_service.png' as the output name
# pylint: disable=W0106
with Diagram('Web Service',
             show=True,        # set to False to not auto-open the generated image file
             direction='LR',     # left-to-right, other options: TB, BT, LR, RL
             #outformat='jpg'  # default: png
             #outformat=['jpg', 'png', 'dot']  # or create all 3 format output files
             #filename='my_diagram'  # override the default filename, without the extension
             #
             # GraphViz dot attributes are supported graph_attr, node_attr and edge_attr - create a dictionary{} of settings containing these attributes:
             #
             #  https://www.graphviz.org/doc/info/attrs.html
             #
             #graph_attr=graph_attr_settings_dict
             #node_attr=node_attr_settings_dict
             #edge_attr=edge_attr_settings_dict
             ):

    # >>  right arrow
    # <<  left arrow
    # -   line with no arrow

    # XXX: the order of rendered diagrams is the reverse of the declaration order

    # appears at bottom
    ELB('lb') >> EC2('web') >> RDS('userdb') >> S3('store')

    ELB('lb') >> EC2('web') >> RDS('userdb') << EC2('stat')

    # appears at top
    # parens to protect against unexpected precedence results combining << >> with -
    (ELB('lb') >> EC2('web')) - EC2('web') >> RDS('userdb')


# Can render directly inside a Jupyter notebook like this:
#
# with Diagram('Simple Diagram') as diag:
#     EC2('web')
# diag
