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
#   https://diagrams.mingrammer.com/docs/nodes/azure
#
#   https://diagrams.mingrammer.com/docs/nodes/gcp
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

from diagrams import Diagram, Cluster, Edge

# AWS resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/aws
#
from diagrams.aws.compute import EC2, ECS, EKS, Lambda
from diagrams.aws.database import RDS, Redshift, ElastiCache
from diagrams.aws.integration import SQS
from diagrams.aws.network import ELB, Route53, VPC
from diagrams.aws.storage import S3

# Azure resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/azure
#
from diagrams.azure.compute import FunctionApps
from diagrams.azure.storage import BlobStorage

# GCP resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/gcp
#
from diagrams.gcp.compute import AppEngine, GKE
from diagrams.gcp.ml import AutoML

# K8s resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/k8s
#
from diagrams.k8s.compute import Pod, StatefulSet
from diagrams.k8s.network import Service
from diagrams.k8s.storage import PV, PVC, StorageClass

# On-premise / Open Source resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/onprem
#
from diagrams.onprem.analytics import Spark
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.aggregator import Fluentd
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Nginx
from diagrams.onprem.queue import Kafka

# Can render directly inside a Jupyter notebook like this:
#
# with Diagram('Simple Diagram') as diag:
#     EC2('web')
# diag

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

with Diagram("Grouped Workers", show=True, direction="TB"):
    # can use variables to connect nodes to the same items
    # lb = ELB("lb")
    # db = RDS("events")
    # lb >> EC2("worker1") >> db
    # lb >> EC2("worker2") >> db
    # lb >> EC2("worker3") >> db
    # lb >> EC2("worker4") >> db
    # lb >> EC2("worker5") >> db

    # but less redundant code than the above can be achieved by grouping the workers into a list[]
    ELB("lb") >> [EC2("worker1"),
                  EC2("worker2"),
                  EC2("worker3"),
                  EC2("worker4"),
                  EC2("worker5")] >> RDS("events")

# Cluster puts a box around RDS nodes, and can connect outside ECS and Route53 to the primary RDS
with Diagram("Simple Web Service with DB Cluster", show=True):
    dns = Route53("dns")
    web = ECS("service")

    with Cluster("DB Cluster"):
        db_primary = RDS("primary")
        db_primary - [RDS("replica1"),
                     RDS("replica2")]

    dns >> web >> db_primary

# Nest clusters
with Diagram("Event Processing", show=True):
    source = EKS("k8s source")

    with Cluster("Event Flows"):
        with Cluster("Event Workers"):
            workers = [ECS("worker1"),
                       ECS("worker2"),
                       ECS("worker3")]

        queue = SQS("event queue")

        with Cluster("Processing"):
            handlers = [Lambda("proc1"),
                        Lambda("proc2"),
                        Lambda("proc3")]

    store = S3("events store")
    dw = Redshift("analytics")

    source >> workers >> queue >> handlers
    handlers >> store
    handlers >> dw

# Edge is an object representing a connection between Nodes with some additional properties
#
# An edge object contains three attributes: label, color and style which mirror corresponding graphviz edge attributes
#
with Diagram(name="Advanced Web Service with On-Premise (colored)", show=True):
    ingress = Nginx("ingress")

    metrics = Prometheus("metric")
    metrics << Edge(color="firebrick", style="dashed") << Grafana("monitoring")

    with Cluster("Service Cluster"):
        grpcsvc = [
            Server("grpc1"),
            Server("grpc2"),
            Server("grpc3")]

    with Cluster("Sessions HA"):
        primary = Redis("session")
        primary \
            - Edge(color="brown", style="dashed") \
            - Redis("replica") \
            << Edge(label="collect") \
            << metrics
        grpcsvc >> Edge(color="brown") >> primary

    with Cluster("Database HA"):
        primary = PostgreSQL("users")
        primary \
            - Edge(color="brown", style="dotted") \
            - PostgreSQL("replica") \
            << Edge(label="collect") \
            << metrics
        grpcsvc >> Edge(color="black") >> primary

    aggregator = Fluentd("logging")
    aggregator \
        >> Edge(label="parse") \
        >> Kafka("stream") \
        >> Edge(color="black", style="bold") \
        >> Spark("analytics")

    ingress \
        >> Edge(color="darkgreen") \
        << grpcsvc \
        >> Edge(color="darkorange") \
        >> aggregator
