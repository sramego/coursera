-- Compute a Histogram

-- local IO-related library
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader as (line:chararray);

-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);

--group the n-triples by subject column
subjects = group ntriples by (subject) PARALLEL 50;

-- flatten the subjects out (because group by produces a tuple of each subject
-- in the first column, and we want each subject ot be a string, not a tuple),
-- and count the number of tuples associated with each object
count_by_subject = foreach subjects generate flatten($0), COUNT($1) as count PARALLEL 50;

-- group the resulting tuples by their intermediate counts
group_by_count = group count_by_subject by $1 PARALLEL 50;

-- compute the final counts for each intermediate count
count_by_count = foreach group_by_count generate flatten($0), COUNT($1) as histo PARALLEL 50;

-- store the results in the folder /user/hadoop/example_2
store count_by_count into '/user/hadoop/example_2' using PigStorage();

=============================================================================
grunt> store count_by_count into '/home/hadoop/example_2' using PigStorage();
17/04/02 15:57:13 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
2749756 [main] INFO  org.apache.pig.tools.pigstats.ScriptState  - Pig features used in the script: GROUP_BY
17/04/02 15:57:13 INFO pigstats.ScriptState: Pig features used in the script: GROUP_BY
17/04/02 15:57:13 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
2749817 [main] INFO  org.apache.pig.data.SchemaTupleBackend  - Key [pig.schematuple] was not set... will not generate code.
17/04/02 15:57:13 INFO data.SchemaTupleBackend: Key [pig.schematuple] was not set... will not generate code.
2749818 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer  - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 15:57:13 INFO optimizer.LogicalPlanOptimizer: {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 15:57:13 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
2749895 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
17/04/02 15:57:13 INFO tez.TezLauncher: Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
2749896 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler  - File concatenation threshold: 100 optimistic? false
17/04/02 15:57:13 INFO plan.TezCompiler: File concatenation threshold: 100 optimistic? false
2749899 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 15:57:13 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
2749901 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 15:57:13 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
2749921 [main] INFO  org.apache.pig.builtin.TextLoader  - Using PigTextInputFormat
17/04/02 15:57:13 INFO builtin.TextLoader: Using PigTextInputFormat
17/04/02 15:57:13 INFO input.FileInputFormat: Total input paths to process : 1
2750061 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths to process : 1
17/04/02 15:57:13 INFO util.MapRedUtil: Total input paths to process : 1
2750061 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths (combined) to process : 1
17/04/02 15:57:13 INFO util.MapRedUtil: Total input paths (combined) to process : 1
17/04/02 15:57:13 INFO hadoop.MRInputHelpers: NumSplits: 1, SerializedSize: 389
2750077 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: myudfs.jar
17/04/02 15:57:13 INFO tez.TezJobCompiler: Local resource: myudfs.jar
2750077 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: pig-0.16.0-amzn-0-core-h2.jar
17/04/02 15:57:13 INFO tez.TezJobCompiler: Local resource: pig-0.16.0-amzn-0-core-h2.jar
2750077 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: antlr-runtime-3.4.jar
17/04/02 15:57:13 INFO tez.TezJobCompiler: Local resource: antlr-runtime-3.4.jar
2750077 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: joda-time-2.8.1.jar
17/04/02 15:57:13 INFO tez.TezJobCompiler: Local resource: joda-time-2.8.1.jar
2750077 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: automaton-1.11-8.jar
17/04/02 15:57:13 INFO tez.TezJobCompiler: Local resource: automaton-1.11-8.jar
17/04/02 15:57:13 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
2750127 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-192: parallelism=1, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:57:13 INFO tez.TezDagBuilder: For vertex - scope-192: parallelism=1, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2750127 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_subject,ntriples,raw,subjects
17/04/02 15:57:13 INFO tez.TezDagBuilder: Processing aliases: count_by_subject,ntriples,raw,subjects
2750127 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: raw[8,6],ntriples[-1,-1],count_by_subject[11,19],subjects[10,11]
17/04/02 15:57:13 INFO tez.TezDagBuilder: Detailed locations: raw[8,6],ntriples[-1,-1],count_by_subject[11,19],subjects[10,11]
2750127 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 15:57:13 INFO tez.TezDagBuilder: Pig features in the vertex: 
2750155 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-193: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:57:13 INFO tez.TezDagBuilder: For vertex - scope-193: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2750156 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_count,count_by_subject,group_by_count
17/04/02 15:57:13 INFO tez.TezDagBuilder: Processing aliases: count_by_count,count_by_subject,group_by_count
2750156 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_subject[11,19],count_by_count[13,17],group_by_count[12,17]
17/04/02 15:57:13 INFO tez.TezDagBuilder: Detailed locations: count_by_subject[11,19],count_by_count[13,17],group_by_count[12,17]
2750156 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY
17/04/02 15:57:13 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY
2750187 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-194: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:57:13 INFO tez.TezDagBuilder: For vertex - scope-194: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2750187 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_count
17/04/02 15:57:13 INFO tez.TezDagBuilder: Processing aliases: count_by_count
2750187 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_count[13,17]
17/04/02 15:57:13 INFO tez.TezDagBuilder: Detailed locations: count_by_count[13,17]
2750187 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY
17/04/02 15:57:13 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY
2750213 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Total estimated parallelism is 101
17/04/02 15:57:13 INFO tez.TezJobCompiler: Total estimated parallelism is 101
2750272 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState  - Pig script settings are added to the job
17/04/02 15:57:13 INFO tez.TezScriptState: Pig script settings are added to the job
17/04/02 15:57:13 INFO client.TezClient: Tez Client Version: [ component=tez-api, version=0.8.4, revision=30eccced8ce8c483445f0aa3175ce725831ff06b, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=2017-02-17T18:19:55Z ]
17/04/02 15:57:13 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 15:57:13 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
17/04/02 15:57:13 INFO client.TezClient: Using org.apache.tez.dag.history.ats.acls.ATSHistoryACLPolicyManager to manage Timeline ACLs
17/04/02 15:57:14 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 15:57:14 INFO client.TezClient: Session mode. Starting session.
17/04/02 15:57:14 INFO client.TezClientUtils: Using tez.lib.uris value from configuration: hdfs:///apps/tez/tez.tar.gz
17/04/02 15:57:14 INFO client.TezClientUtils: Using tez.lib.uris.classpath value from configuration: null
17/04/02 15:57:14 INFO client.TezClient: Tez system stage directory hdfs://ip-172-31-43-94.us-west-2.compute.internal:8020/tmp/temp458034843/.tez/application_1491115920200_0003 doesn't exist and is created
17/04/02 15:57:14 INFO acls.ATSHistoryACLPolicyManager: Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1491115920200_0003
17/04/02 15:57:14 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 15:57:14 INFO impl.YarnClientImpl: Submitted application application_1491115920200_0003
17/04/02 15:57:14 INFO client.TezClient: The url to track the Tez Session: http://ip-172-31-43-94.us-west-2.compute.internal:20888/proxy/application_1491115920200_0003/
2757268 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitting DAG PigLatin:DefaultJobName-0_scope-5
17/04/02 15:57:20 INFO tez.TezJob: Submitting DAG PigLatin:DefaultJobName-0_scope-5
17/04/02 15:57:20 INFO client.TezClient: Submitting dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0003, dagName=PigLatin:DefaultJobName-0_scope-5, callerContext={ context=PIG, callerType=PIG_SCRIPT_ID, callerId=PIG-default-ce74cf2a-ca84-4255-97af-b94147e40ad8 }
17/04/02 15:57:21 INFO client.TezClient: Submitted dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0003, dagName=PigLatin:DefaultJobName-0_scope-5
17/04/02 15:57:22 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 15:57:22 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
2758536 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitted DAG PigLatin:DefaultJobName-0_scope-5. Application id: application_1491115920200_0003
17/04/02 15:57:22 INFO tez.TezJob: Submitted DAG PigLatin:DefaultJobName-0_scope-5. Application id: application_1491115920200_0003
2759246 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - HadoopJobId: job_1491115920200_0003
17/04/02 15:57:22 INFO tez.TezLauncher: HadoopJobId: job_1491115920200_0003
2759544 [Timer-2] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 101 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 15:57:23 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 101 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
2779544 [Timer-2] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 101 Succeeded: 6 Running: 1 Failed: 0 Killed: 0 KilledTaskAttempts: 1, diagnostics=, counters=null
17/04/02 15:57:43 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 101 Succeeded: 6 Running: 1 Failed: 0 Killed: 0 KilledTaskAttempts: 1, diagnostics=, counters=null
2799544 [Timer-2] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 101 Succeeded: 59 Running: 0 Failed: 0 Killed: 0 KilledTaskAttempts: 3, diagnostics=, counters=null
17/04/02 15:58:03 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 101 Succeeded: 59 Running: 0 Failed: 0 Killed: 0 KilledTaskAttempts: 3, diagnostics=, counters=null
2807818 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=SUCCEEDED, progress=TotalTasks: 101 Succeeded: 101 Running: 0 Failed: 0 Killed: 0 KilledTaskAttempts: 3, diagnostics=, counters=Counters: 64
	org.apache.tez.common.counters.DAGCounter
		NUM_KILLED_TASKS=3
		NUM_SUCCEEDED_TASKS=101
		TOTAL_LAUNCHED_TASKS=101
		RACK_LOCAL_TASKS=1
		AM_CPU_MILLISECONDS=7630
		AM_GC_TIME_MILLIS=19
	File System Counters
		FILE_BYTES_READ=310653
		FILE_BYTES_WRITTEN=119816
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=10
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=244662
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=3
		REDUCE_INPUT_GROUPS=336
		REDUCE_INPUT_RECORDS=360
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=720
		NUM_SHUFFLED_INPUTS=51
		NUM_SKIPPED_INPUTS=2499
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=51
		GC_TIME_MILLIS=2088
		CPU_MILLISECONDS=40160
		PHYSICAL_MEMORY_BYTES=123897643008
		VIRTUAL_MEMORY_BYTES=454396813312
		COMMITTED_HEAP_BYTES=123897643008
		INPUT_RECORDS_PROCESSED=1000
		INPUT_SPLIT_LENGTH_BYTES=244662
		OUTPUT_RECORDS=1336
		OUTPUT_BYTES=80010
		OUTPUT_BYTES_WITH_OVERHEAD=41818
		OUTPUT_BYTES_PHYSICAL=58208
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=8228
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=51
		SHUFFLE_BYTES=8228
		SHUFFLE_BYTES_DECOMPRESSED=26824
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=8228
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=1254
		MERGE_PHASE_TIME=1431
		FIRST_EVENT_RECEIVED=955
		LAST_EVENT_RECEIVED=1016
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=360
		COMBINE_OUTPUT_RECORDS=1334
17/04/02 15:58:11 INFO tez.TezJob: DAG Status: status=SUCCEEDED, progress=TotalTasks: 101 Succeeded: 101 Running: 0 Failed: 0 Killed: 0 KilledTaskAttempts: 3, diagnostics=, counters=Counters: 64
	org.apache.tez.common.counters.DAGCounter
		NUM_KILLED_TASKS=3
		NUM_SUCCEEDED_TASKS=101
		TOTAL_LAUNCHED_TASKS=101
		RACK_LOCAL_TASKS=1
		AM_CPU_MILLISECONDS=7630
		AM_GC_TIME_MILLIS=19
	File System Counters
		FILE_BYTES_READ=310653
		FILE_BYTES_WRITTEN=119816
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=10
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=244662
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=3
		REDUCE_INPUT_GROUPS=336
		REDUCE_INPUT_RECORDS=360
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=720
		NUM_SHUFFLED_INPUTS=51
		NUM_SKIPPED_INPUTS=2499
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=51
		GC_TIME_MILLIS=2088
		CPU_MILLISECONDS=40160
		PHYSICAL_MEMORY_BYTES=123897643008
		VIRTUAL_MEMORY_BYTES=454396813312
		COMMITTED_HEAP_BYTES=123897643008
		INPUT_RECORDS_PROCESSED=1000
		INPUT_SPLIT_LENGTH_BYTES=244662
		OUTPUT_RECORDS=1336
		OUTPUT_BYTES=80010
		OUTPUT_BYTES_WITH_OVERHEAD=41818
		OUTPUT_BYTES_PHYSICAL=58208
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=8228
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=51
		SHUFFLE_BYTES=8228
		SHUFFLE_BYTES_DECOMPRESSED=26824
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=8228
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=1254
		MERGE_PHASE_TIME=1431
		FIRST_EVENT_RECEIVED=955
		LAST_EVENT_RECEIVED=1016
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=360
		COMBINE_OUTPUT_RECORDS=1334
17/04/02 15:58:11 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
2808258 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats  - Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 15:57:13                                                                                 
          FinishedAt: 2017-04-02 15:58:11                                                                                 
            Features: GROUP_BY                                                                                            

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-5                                                                   
                           ApplicationId: job_1491115920200_0003                                                                              
                      TotalLaunchedTasks: 101                                                                                                 
                           FileBytesRead: 310653                                                                                              
                        FileBytesWritten: 119816                                                                                              
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 10                                                                                                  
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-192	->	Tez vertex scope-193,
Tez vertex scope-193	->	Tez vertex scope-194,
Tez vertex scope-194

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-192          1          1           1000                    0           1000           2416             9053              0                0 count_by_subject,ntriples,raw,subjects		
scope-193         50         50              0                  334            334         251972           110763              0                0 count_by_count,count_by_subject,group_by_count	GROUP_BY	
scope-194         50         50              0                   26              2          56265                0              0               10 count_by_count	GROUP_BY	/home/hadoop/example_2,

Input(s):
Successfully read 1000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file"

Output(s):
Successfully stored 2 records (10 bytes) in: "/home/hadoop/example_2"

17/04/02 15:58:11 INFO tez.TezPigScriptStats: Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 15:57:13                                                                                 
          FinishedAt: 2017-04-02 15:58:11                                                                                 
            Features: GROUP_BY                                                                                            

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-5                                                                   
                           ApplicationId: job_1491115920200_0003                                                                              
                      TotalLaunchedTasks: 101                                                                                                 
                           FileBytesRead: 310653                                                                                              
                        FileBytesWritten: 119816                                                                                              
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 10                                                                                                  
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-192	->	Tez vertex scope-193,
Tez vertex scope-193	->	Tez vertex scope-194,
Tez vertex scope-194

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-192          1          1           1000                    0           1000           2416             9053              0                0 count_by_subject,ntriples,raw,subjects		
scope-193         50         50              0                  334            334         251972           110763              0                0 count_by_count,count_by_subject,group_by_count	GROUP_BY	
scope-194         50         50              0                   26              2          56265                0              0               10 count_by_count	GROUP_BY	/home/hadoop/example_2,

Input(s):
Successfully read 1000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file"

Output(s):
Successfully stored 2 records (10 bytes) in: "/home/hadoop/example_2"

grunt> 

