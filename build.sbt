//
//  Author: Hari Sekhon
//  Date: [% DATE # 2015-05-23 09:10:31 +0100 (Sat, 23 May 2015) %]
//
//  vim:ts=4:sts=4:sw=4:et:filetype=java
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

name := "[% NAME %]"

version := "0.1"

scalaVersion := "2.10.4"

//resolvers += "clojars" at "https://clojars.org/repo"
//resolvers += "conjars" at "http://conjars.org/repo"

//unmanagedBase := baseDirectory.value / "lib/target"

mainClass := Some("com.linkedin.harisekhon.[% NAME % ].Main")

unmanagedClasspath in Test += baseDirectory.value / "special-resources"

unmanagedClasspath in (Compile, runMain) += baseDirectory.value / "special-resources"

libraryDependencies ++= Seq(
    // %% appends scala version to spark-core
    "org.apache.spark" %% "spark-core" % "1.6.1" % "provided",
    "org.apache.spark" %% "spark-streaming" % "1.6.1" % "provided",
    "org.apache.spark" %% "spark-streaming-kafka" % "1.6.1",
    "org.apache.hadoop" % "hadoop-client" % "2.7.2" % "provided",
    //"org.elasticsearch" % "elasticsearch" % "1.4.1",
    // this pulled in loads of deps for Clojure and others which wouldn't resolve, using elasticsearch-spark instead
    //"org.elasticsearch" % "elasticsearch-hadoop" % "2.0.2",
    "org.elasticsearch" %% "elasticsearch-spark" % "2.1.0.Beta4",
    // Spark has it's own older version of commons-cli and using the newer commons-cli 1.3 non-static API methods causes:
    // Exception in thread "main" java.lang.NoSuchMethodError: org.apache.commons.cli.Option.builder(Ljava/lang/String;)Lorg/apache/commons/cli/Option$Builder;
    "commons-cli" % "commons-cli" % "1.3.1",
    // "net.sf.jopt-simple" % "jopt-simple" % "5.0.2"
    "org.scalatest" %% "scalatest" % "2.2.4" % "test"
    "commons-cli" % "commons-cli" % "1.3.1",
)
