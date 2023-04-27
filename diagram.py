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

# pylint: disable=E0401,W0611,C0301,W0404

# ============================================================================ #

import os
from diagrams import Diagram, Cluster, Edge

# ============================================================================ #
# On-premise / Open Source resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/onprem
#
#   'onprem' includes Cloud SaaS CI/CD and major Open Source products including:
#
#   - CI/CD - Jenkins, ArgoCD, GitHub Actions, GitLab CI, CircleCI, Concourse, TeamCity, Tekton, Spinnaker
#   - Databases - MySQL, PostgreSQL, Cassandra, HBase, MongoDB, Oracle, Couchbase, Neo4J, InfluxDB
#   - Docker, Redis, Terraform, Vault, Ansible, Puppet, AWX, Atlantis
#   - Apache httpd, Nginx, Kong, Traefik, HAProxy, Consul, Etcd
#   - Analytics - Spark, Databricks, Kafka, Dbt, Flink, Hadoop, Hive, Presto, ZooKeeper, Storm, Airflow, Tableau
#   - Queues - Kafka, RabbitMQ, ActiveMQ, Celery
#   - Monitoring - Prometheus, Grafana, Datadog, Thanos, Splunk, Nagios
#   - K8s ecosystem - Prometheus, ArgoCD, FluxCD, Fluentd, Etcd, Cert Manager, Lets Encrypt

from diagrams.onprem.aggregator import Fluentd
from diagrams.onprem.analytics import Beam, Databricks, Dbt, Flink, Hadoop, Hive, Presto, Spark, Superset, Tableau
from diagrams.onprem.cd import Spinnaker, Tekton, TektonCli
from diagrams.onprem.certificates import CertManager, LetsEncrypt
from diagrams.onprem.ci import Jenkins, GithubActions, GitlabCI, CircleCI, ConcourseCI, Teamcity
from diagrams.onprem.client import Users
from diagrams.onprem.compute import Nomad, Server
from diagrams.onprem.container import Containerd, Docker, K3S
from diagrams.onprem.database import Cassandra, Couchbase, CouchDB, Druid, HBase, InfluxDB, MariaDB, MongoDB, MSSQL, MySQL, Neo4J, Oracle, PostgreSQL
from diagrams.onprem.dns import Coredns, Powerdns
from diagrams.onprem.gitops import ArgoCD, Flagger, Flux
from diagrams.onprem.iac import Ansible, Atlantis, Awx, Puppet, Terraform
from diagrams.onprem.inmemory import Aerospike, Hazelcast, Memcached, Redis
from diagrams.onprem.monitoring import Datadog, Dynatrace, Grafana, Nagios, Newrelic, Prometheus, PrometheusOperator, Sentry, Splunk, Thanos, Zabbix
from diagrams.onprem.logging import FluentBit, Graylog, Loki, RSyslog, SyslogNg
from diagrams.onprem.network import Ambassador, Apache, Bind9, Consul, Envoy, Etcd, Glassfish, Gunicorn, HAProxy, Internet, Istio, Jetty, Kong, Nginx, Tomcat, Traefik, Zookeeper
from diagrams.onprem.queue import ActiveMQ, Celery, Kafka, Nats, RabbitMQ, ZeroMQ
from diagrams.onprem.registry import Harbor, Jfrog
from diagrams.onprem.search import Solr
from diagrams.onprem.security import Bitwarden, Trivy, Vault
from diagrams.onprem.storage import Ceph, Glusterfs, Portworx
from diagrams.onprem.tracing import Jaeger
from diagrams.onprem.vcs import Git, Github, Gitlab, Svn
from diagrams.onprem.workflow import Airflow, KubeFlow, NiFi

# ============================================================================ #
# AWS resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/aws
#

from diagrams.aws.analytics import Athena, Cloudsearch, ElasticsearchService, Glue, Kinesis  # , Redshift
from diagrams.aws.compute import Batch, Compute, EC2, ECR, ECS, EKS, Lambda
from diagrams.aws.database import Aurora, ElastiCache, ElasticacheForRedis, RDS, Redshift, RDSInstance, RDSMariadbInstance, RDSMysqlInstance, RDSPostgresqlInstance, RDSSqlServerInstance
from diagrams.aws.devtools import Codebuild, Codecommit, Codedeploy, Codepipeline, Codestar
from diagrams.aws.general import User, Users
from diagrams.aws.integration import SNS, SQS, StepFunctions
from diagrams.aws.iot import IotGreengrass
from diagrams.aws.management import AutoScaling, Cloudtrail, Cloudwatch, Config, ControlTower, Organizations, SSM, TrustedAdvisor, WellArchitectedTool
from diagrams.aws.migration import DatabaseMigrationService, Datasync, DatasyncAgent, ServerMigrationService, Snowball, SnowballEdge, TransferForSftp
from diagrams.aws.ml import Sagemaker
from diagrams.aws.network import APIGateway, ClientVpn, CloudFront, ELB, ALB, NLB, Route53, VPC
from diagrams.aws.security import KMS, Macie, SecretsManager, WAF
from diagrams.aws.storage import S3

# ============================================================================ #
# Azure resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/azure
#

from diagrams.azure.analytics import Databricks
from diagrams.azure.compute import AvailabilitySets, AKS, ContainerInstances, ACR, FunctionApps, VM
from diagrams.azure.database import BlobStorage, DataFactory, DataLake, DatabaseForMariadbServers, DatabaseForMysqlServers, DatabaseForPostgresqlServers, SQLDatabases, SQLServers, SQL
from diagrams.azure.devops import Artifacts, Devops, Pipelines, Repos, TestPlans
from diagrams.azure.general import Reservations, Resource, Resourcegroups, Tags
from diagrams.azure.identity import ActiveDirectory, ADDomainServices, AppRegistrations, EnterpriseApplications, Groups, Users
from diagrams.azure.integration import APIManagement, AppConfiguration, DataCatalog, LogicApps, ServiceBus, SoftwareAsAService
from diagrams.azure.iot import DeviceProvisioningServices, IotHubSecurity, IotHub, Maps, Sphere
from diagrams.azure.migration import DataBox, DataBoxEdge, DatabaseMigrationServices
from diagrams.azure.ml import BatchAI, BotServices
from diagrams.azure.network import ApplicationGateway, Firewall, LoadBalancers, Subnets, VirtualNetworks, VirtualNetworkGateways, VirtualWans
from diagrams.azure.security import ApplicationSecurityGroups, KeyVaults, SecurityCenter, Sentinel
from diagrams.azure.storage import BlobStorage, GeneralStorage, NetappFiles, StorageAccounts, StorageExplorer, TableStorage
from diagrams.azure.web import APIConnections, AppServices, Search

# ============================================================================ #
# GCP resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/gcp
#

from diagrams.gcp.analytics import BigQuery, Composer, DataCatalog, Dataflow, Dataprep, Dataproc, PubSub
from diagrams.gcp.api import APIGateway, Endpoints
from diagrams.gcp.compute import AppEngine, GCE, GKE, GCF, Run
from diagrams.gcp.database import BigTable, Datastore, Memorystore, Spanner, SQL
from diagrams.gcp.devtools import Build, Code, GCR, Scheduler, SDK, SourceRepositories
from diagrams.gcp.iot import IotCore
from diagrams.gcp.ml import AutoML, AutomlVision, InferenceAPI, NaturalLanguageAPI, RecommendationsAI, SpeechToText, TextToSpeech, TranslationAPI, VisionAPI
from diagrams.gcp.network import Armor, CDN, DNS, ExternalIpAddresses, FirewallRules, LoadBalancing, NAT, Network, Router, Routes, StandardNetworkTier, TrafficDirector, VPC, VPN
from diagrams.gcp.operations import Monitoring
from diagrams.gcp.security import Iam, IAP, KMS, ResourceManager, SecurityCommandCenter, SecurityScanner
from diagrams.gcp.storage import GCS, Filestore, PersistentDisk

# ============================================================================ #
# K8s resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/k8s
#

from diagrams.k8s.clusterconfig import HPA, LimitRange, Quota
from diagrams.k8s.compute import Cronjob, Deployment, DaemonSet, Job, Pod, ReplicaSet, StatefulSet
from diagrams.k8s.controlplane import API, CCM, ControllerManager, Kubelet, KubeProxy, Scheduler
from diagrams.k8s.ecosystem import ExternalDns, Helm, Krew, Kustomize
from diagrams.k8s.group import Namespace
from diagrams.k8s.infra import ETCD, Master, Node
from diagrams.k8s.network import Endpoint, Ingress, NetworkPolicy, Service
from diagrams.k8s.others import CRD, PSP
from diagrams.k8s.podconfig import ConfigMap, Secret
from diagrams.k8s.rbac import ClusterRole, ClusterRoleBinding, Group, RoleBinding, Role, ServiceAccount, User
from diagrams.k8s.storage import PV, PVC, StorageClass, Volume

# ============================================================================ #
# OpenStack resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/openstack
#

from diagrams.openstack.compute import Nova
from diagrams.openstack.deployment import Ansible, Chef, Helm
from diagrams.openstack.sharedservices import Glance, Keystone
from diagrams.openstack.storage import Cinder, Swift

# ============================================================================ #
# SaaS resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/saas
#

#from diagrams.saas.alerting import Newrelic
from diagrams.saas.logging import Datadog, Newrelic
from diagrams.saas.analytics import Snowflake
from diagrams.saas.cdn import Akamai, Cloudflare, Fastly
from diagrams.saas.chat import Slack, Teams
from diagrams.saas.identity import Auth0, Okta
from diagrams.saas.social import Facebook, Twitter

# ============================================================================ #
# Elastic resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/elastic
#

from diagrams.elastic.agent import Agent
from diagrams.elastic.beats import APM, Auditbeat, Filebeat, Functionbeat, Heartbeat, Metricbeat, Packetbeat
from diagrams.elastic.elasticsearch import Alerting, Beats, ElasticSearch, Kibana, Logstash, MachineLearning, Maps, Monitoring, SQL, Stack
from diagrams.elastic.enterprisesearch import AppSearch, Crawler, EnterpriseSearch
from diagrams.elastic.observability import APM, Logs, Metrics, Observability, Uptime
from diagrams.elastic.orchestration import ECE, ECK
from diagrams.elastic.saas import Cloud, Elastic
from diagrams.elastic.security import Security, SIEM

# ============================================================================ #
# DigitalOcean resources:
#
#   https://diagrams.mingrammer.com/docs/nodes/digitalocean

from diagrams.digitalocean.compute import Containers, Docker, Droplet, K8SCluster, K8SNodePool, K8SNode
from diagrams.digitalocean.database import DbaasPrimary, DbaasReadOnly, DbaasStandby
from diagrams.digitalocean.network import Certificate, DomainRegistration, Domain, Firewall, FloatingIp, InternetGateway, LoadBalancer, ManagedVpn, Vpc
from diagrams.digitalocean.storage import Folder, Space, VolumeSnapshot, Volume

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
# Programming - flowcharts, programming languages and frameworks
#
#   https://diagrams.mingrammer.com/docs/nodes/programming
#

from diagrams.programming.flowchart import Action, Database, Decision, Delay, Document, InputOutput, MultipleDocuments
from diagrams.programming.framework import Angular, Django, FastAPI, Flask, GraphQL, Rails, React, Spring
from diagrams.programming.language import Bash, Go, Python, R, Ruby, PHP, JavaScript, Rust, TypeScript
from diagrams.programming.language import C, Cpp, Csharp, Java, Kotlin, Scala

# ============================================================================ #
# C4 - Software Architecture - boxes with Name, Technology and Description inside
#
#   https://diagrams.mingrammer.com/docs/nodes/c4
#

from diagrams.c4 import Person, Container, Database, System, SystemBoundary, Relationship

# ============================================================================ #
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

# diagram name results in '[% NAME %].png' lowercased with underscores if filename isn't specified
# pylint: disable=W0104,W0106
with Diagram('[% NAME %]',
             #show=True,        # set to False to not auto-open the generated image file
             show=not bool(os.environ.get('CI', 0)),
             # direction seems to set graphviz graph_attr rankdir, which takes precedence if set
             direction='LR',     # left-to-right, other options: TB, BT, LR, RL
             #outformat='jpg',   # default: png
             #outformat=['jpg', 'png', 'dot']  # or create all 3 format output files
             #filename='images/[% NAME %]',  # override the default filename, without the extension
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
