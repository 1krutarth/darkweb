package metadata_test;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Base64Extractor {
	public static class Base64Extract extends Mapper< Object, Text, IntWritable, Text>{
		private Text word = new Text();
		private final static IntWritable one = new IntWritable(1);
		
		public void map( Object key, Text value, Context context ) throws IOException, InterruptedException {
			String pattern_1 = ",(.*)'";
			String pattern_2 = ",(.*)";

			Pattern p1 = Pattern.compile( pattern_1 );
			Pattern p2 = Pattern.compile( pattern_2 );
			
			String line = value.toString();
			if( line.contains( "background" ) ){
				Matcher m = p1.matcher( line );
				if( m.find() ){
					String b64_code = m.group(0);
					word.set( b64_code.substring(1, b64_code.length()) );
					context.write(one, word );
				}
			}
//			else if( line.contains( "content" ) ){
//				Matcher m = p2.matcher( line );
//				if( m.find() ){
//					String b64_code = m.group(0);
//					word.set( b64_code.substring(1, b64_code.length()) );
//					context.write( one, word );
//				}
//			}
		}
	}
	
	public static class Base64Output extends Reducer<IntWritable, Text, IntWritable, Text> {
		
		public void reduce( IntWritable key, Text value, Context context ) throws IOException, InterruptedException {
			context.write(key, value);
		}
	}
	
	public static void main( String[] args ) throws Exception{
		Configuration conf = new Configuration();
		Job job = Job.getInstance( conf, "SilkRoad2" );
		job.setJarByClass( MetadataExtractor.class );
		job.setMapperClass( Base64Extract.class );
		job.setCombinerClass( Base64Output.class );
		job.setReducerClass( Base64Output.class );
		job.setOutputKeyClass( IntWritable.class );
		job.setOutputValueClass( Text.class );
		FileInputFormat.addInputPath(job, new Path( args[0] ));
		FileOutputFormat.setOutputPath(job, new Path( args[1] ));
		System.exit( job.waitForCompletion(true)? 0:1 );
	}
}
