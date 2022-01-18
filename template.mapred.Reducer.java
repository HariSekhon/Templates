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
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

// input, input, output, output
public class MyReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

  /*
   * The reduce method runs once for each key received from
   * the shuffle and sort phase of the MapReduce framework.
   * The method receives a key of type Text, a set of values of type
   * IntWritable, and a Context object.
   */
    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

        // TODO: put logic here

        context.write(key, new IntWritable(value));
    }
}
