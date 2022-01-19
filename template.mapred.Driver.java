//
//  Author: Hari Sekhon
//  Date: [% DATE # 2013-04-18 14:41:17 +0100 (Thu, 18 Apr 2013) %]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% VIM_TAGS %]

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Job;

import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.conf.Configuration;

import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

public class MyDriver extends Configured implements Tool {

    @Override
    public int run(String[] args) throws Exception {

        if (args.length != 2) {
          System.out.printf("Usage: MyDriver <input dir> <output dir>\n");
          return -1;
        }

        Job job = new Job(getConf());
        job.setJarByClass(MyMapper.class);
        job.setJobName("MyJob");

        // will read all files except .* _* in this dir
        // globs can be specified to restrict input files
        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.setInputFormatClass(KeyValueTextInputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);

        job.setMapperClass(MyMapper.class);
        // job.setCombinerClass(MyCombiner.class); // must have the same input/output key/value types as the Reducer class
        job.setReducerClass(MyReducer.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        boolean success = job.waitForCompletion(true);
        return success ? 0 : 1;
    }

    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new Configuration(), new MyDriver(), args);
        System.exit(exitCode);
    }
}
