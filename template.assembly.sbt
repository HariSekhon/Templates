//
//  Author: Hari Sekhon
//  Date: [% DATE # 2015-05-25 23:27:15 +0100 (Mon, 25 May 2015) %]
//
//  [% VIM_TAGS %]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

// https://github.com/sbt/sbt-assembly

import AssemblyKeys._

assemblySettings

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case PathList("META-INF", "maven","org.slf4j","slf4j-api", p) if p.startsWith("pom")        => MergeStrategy.discard
    case PathList("com", "esotericsoftware", "minlog", p)         if p.startsWith("Log")        => MergeStrategy.first
    // too many things here condensed down to just dedupe all
    case PathList("com", "google", "common", "base", p)                                         => MergeStrategy.first
    case PathList("org", "apache", "commons", p @ _*)                                           => MergeStrategy.first
    case PathList("org", "apache", "hadoop", p @ _*)        if p.contains("package-info.class") => MergeStrategy.first
    case PathList("org", "apache", "spark", "unused", p @ _*)                                   => MergeStrategy.first
    case x => old(x)
  }
}
