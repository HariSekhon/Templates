//
//  Author: Hari Sekhon
//  Date: [% DATE # 2013-04-18 14:38:57 +0100 (Thu, 18 Apr 2013) %]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% VIM_TAGS %]

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

// input, input, output, output
public class MyMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

    @Override
    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {

        // TODO: put logic here

        context.write(key, new IntWritable(value));

    }
}
