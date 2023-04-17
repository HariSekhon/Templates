#!/usr/bin/env python3
#  coding=utf-8
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: [% DATE  # 2023-04-14 13:54:52 +0100 (Fri, 14 Apr 2023) %]
#
#  [% URL # https://github.com/HariSekhon/Templates %]
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn
#  and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

"""

[% NAME %]

"""

__author__ = 'Hari Sekhon'
__version__ = '0.1'

# ============================================================================ #
# The OG

# from graphviz import Digraph
# g = Digraph('G')
# g.edge('Hello, World')
# g

# ============================================================================ #
# https://diagrams.mingrammer.com/docs/getting-started/examples

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
#   https://diagrams.mingrammer.com/docs/nodes/azure
#
#   https://diagrams.mingrammer.com/docs/nodes/gcp
#
#   https://diagrams.mingrammer.com/docs/nodes/k8s
#
#   https://diagrams.mingrammer.com/docs/nodes/openstack
#
#   https://diagrams.mingrammer.com/docs/nodes/elastic
#
#   https://diagrams.mingrammer.com/docs/nodes/digitalocean
#
#   https://diagrams.mingrammer.com/docs/nodes/saas  # Snowflake, Newrelic, CDNs, Akamai, Cloudflare, Fastly,
#                                                      Slack, Teams, Auth0, Okta, DataDog, Facebook, Twitter
#
#   https://diagrams.mingrammer.com/docs/nodes/generic  # Datacenter, Operating Systems, Virtualization, Mobile Devices
#
#   https://diagrams.mingrammer.com/docs/nodes/programming

# pylint: disable=E0401,W0611

# ============================================================================ #

import os
from diagrams import Diagram, Cluster, Edge

# ============================================================================ #
# AWS resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/aws
#

from diagrams.aws.compute import EC2, ECS, EKS, Lambda
from diagrams.aws.database import RDS, Redshift, ElastiCache, Aurora
from diagrams.aws.integration import SQS
from diagrams.aws.network import ELB, Route53, CloudFront, VPC
from diagrams.aws.storage import S3
from diagrams.aws.general import Users

# ============================================================================ #
# Azure resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/azure
#

from diagrams.azure.compute import FunctionApps
from diagrams.azure.storage import BlobStorage

# ============================================================================ #
# GCP resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/gcp
#

from diagrams.gcp.analytics import BigQuery, Dataflow, PubSub
from diagrams.gcp.compute import AppEngine, GKE, Functions
from diagrams.gcp.database import BigTable
from diagrams.gcp.iot import IotCore
from diagrams.gcp.ml import AutoML
from diagrams.gcp.network import DNS, LoadBalancing
from diagrams.gcp.storage import GCS

# ============================================================================ #
# K8s resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/k8s
#

from diagrams.k8s.clusterconfig import HPA
from diagrams.k8s.compute import Deployment, Pod, ReplicaSet, StatefulSet
from diagrams.k8s.network import Ingress, Service
from diagrams.k8s.storage import PV, PVC, StorageClass

# ============================================================================ #
# On-premise / Open Source resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/onprem
#

from diagrams.onprem.aggregator import Fluentd
from diagrams.onprem.analytics import Spark
from diagrams.onprem.certificates import CertManager, LetsEncrypt
from diagrams.onprem.client import Users
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.gitops import ArgoCD
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Nginx, Kong, Traefik
from diagrams.onprem.queue import Kafka
from diagrams.onprem.vcs import Github


# ============================================================================ #
# SaaS:
#
#   https://diagrams.mingrammer.com/docs/nodes/saas
#

#from diagrams.saas.alerting import Newrelic
from diagrams.saas.logging import Datadog, Newrelic
from diagrams.saas.analytics import Snowflake
from diagrams.saas.cdn import Akamai, Cloudflare, Fastly
from diagrams.saas.chat import Slack, Teams
from diagrams.saas.identity import Auth0, Okta

# ============================================================================ #
# Generic - Datacentre, Operating Systems, Virtualization, Mobile Devices:
#
#   https://diagrams.mingrammer.com/docs/nodes/generic
#

from diagrams.generic.place import Datacenter
from diagrams.generic.compute import Rack
from diagrams.generic.storage import Storage
from diagrams.generic.network import Firewall, Router, Subnet, Switch, VPN
from diagrams.generic.os import LinuxGeneral, Debian, Ubuntu, RedHat, Centos
from diagrams.generic.os import IOS, Android, Raspbian, Windows
from diagrams.generic.virtualization import Vmware, Virtualbox, XEN

# ============================================================================ #
#
# Programming - flowcharts, programming languages and frameworks
#
#   https://diagrams.mingrammer.com/docs/nodes/programming
#

from diagrams.programming.flowchart import Action, Database, Decision, Delay, Document, InputOutput, MultipleDocuments
from diagrams.programming.framework import Angular, Django, FastAPI, Flask, GraphQL, Rails, React, Spring
from diagrams.programming.language import Bash, Go, Python, R, Ruby, PHP, JavaScript, Rust, TypeScript
from diagrams.programming.language import C, Cpp, Csharp, Java, Kotlin, Scala

# ============================================================================ #
#
# C4 - Software Architecture - boxes with Name, Technology and Description inside
#
#   https://diagrams.mingrammer.com/docs/nodes/c4
#

from diagrams.c4 import Person, Container, Database, System, SystemBoundary, Relationship

# ============================================================================ #
#
# Custom - for creating a custom object using a downloaded image
#
#   https://diagrams.mingrammer.com/docs/nodes/custom
#

from diagrams.custom import Custom


# ============================================================================ #
# Can render directly inside a Jupyter notebook like this:
#
# with Diagram('Simple Diagram') as diag:
#     EC2('web')
# diag


# Examples:
#
#   https://github.com/HariSekhon/Diagrams-as-Code
#
#   https://diagrams.mingrammer.com/docs/getting-started/examples


# https://www.graphviz.org/doc/info/attrs.html
graph_attr = {
    "splines": "spline",  # rounded arrows, much nicer
}

# diagram name results in 'web_service.png' as the output name
# pylint: disable=W0104,W0106
with Diagram('Web Service',
             #show=True,        # set to False to not auto-open the generated image file
             show=not bool(os.environ.get('CI', 0)),
             direction='LR',     # left-to-right, other options: TB, BT, LR, RL
             #outformat='jpg'  # default: png
             #outformat=['jpg', 'png', 'dot']  # or create all 3 format output files
             #filename='my_diagram'  # override the default filename, without the extension
             #
             # GraphViz dot attributes are supported graph_attr, node_attr and edge_attr
             # create a dictionary{} of settings containing these attributes:
             #
             #  https://www.graphviz.org/doc/info/attrs.html
             #
             graph_attr=graph_attr,
             #node_attr=node_attr,
             #edge_attr=edge_attr,
             ):

    # >>  right arrow
    # <<  left arrow
    # -   line with no arrow

    # NOTE: the order of rendered diagrams is the reverse of the declaration order

    # appears at bottom
    ELB('lb') >> EC2('web') >> RDS('userdb') >> S3('store')

    ELB('lb') >> EC2('web') >> RDS('userdb') << EC2('stat')

    # appears at top
    # parens to protect against unexpected precedence results combining << >> with -
    (ELB('lb') >> EC2('web')) - EC2('web') >> RDS('userdb')

    # Group nodes using a Python list[]
    #
    #   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/aws_load_balanced_web_farm.py
    #
    with Cluster("Web Services"):
        svc_group = [EC2("web1"),
                     EC2("web2"),
                     EC2("web3")]
    ELB('lb') >> svc_group

# ============================================================================ #
# Grouped Nodes Load Balanced Web Farm top-to-bottom orientation
#
#   load_balanced_web_farm.py

# ============================================================================ #
# Clustered node examples:
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/aws_web_service_db_cluster.py
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/aws_clustered_web_services.py
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/gcp_pubsub_analytics.py
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/kubernetes_deployment_hpa_ingress.py
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/kubernetes_stateful_architecture.py
#
# Nested Clusters:
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/aws_event_processing.py

# ============================================================================ #
# Edge is an object representing a connection between Nodes with some additional properties
#
# An edge object contains three attributes: label, color and style which mirror corresponding graphviz edge attributes

# Example with fancy edges between nodes:
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/advanced_web_services_open_source.py

# ============================================================================ #
# Download an image to be used in a Custom node
#
#   https://github.com/HariSekhon/Diagrams-as-Code/blob/master/rabbitmq_broker_with_custom_icon.py
#
# pylint: disable=C0103
#rabbitmq_url = "https://jpadilla.github.io/rabbitmqapp/assets/img/icon.png"
#rabbitmq_icon = "rabbitmq.png"

#import os
#from urllib.request import urlretrieve

# download to $PWD/rabbitmq.png
#urlretrieve(rabbitmq_url, rabbitmq_icon)

#rabbitmq_object = Custom("Message queue", rabbitmq_icon)
#os.remove(rabbitmq_icon)
