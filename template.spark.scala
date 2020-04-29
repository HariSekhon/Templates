//
//  Author: Hari Sekhon
//  Date: 2015-03-15 20:33:50 +0000 (Sun, 15 Mar 2015)
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

// XXX: Description

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object MyApp {

    def main(args: Array[String]){

        val conf  = new SparkConf().setAppName("Hari's MyApp")
        val sc = new SparkContext(conf)

        sc.stop()
    }

}
