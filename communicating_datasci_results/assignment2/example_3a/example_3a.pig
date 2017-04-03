-- Compute a Join

-- local IO-related library
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader as (line:chararray);

-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);

-- filter the data to tuples whose subject matches
filtered = filter ntriples by (subject matches '.*business.*');

-- make another copy of the filtered collection
filtered_copy = foreach filtered generate $0 as subject2, $1 as predicate2, $2 as object2 PARALLEL 50;

-- join the two 
join_out = join filtered by subject, filtered_copy by subject2;

-- distinct the join result
join_out_dist = distinct join_out;

-- store the results in the folder /user/hadoop/example_3a_1
store join_out_dist into '/user/hadoop/example_3a_1' using PigStorage();

====================================================================================================

grunt> store join_out_dist into '/user/hadoop/example_3a_1' using PigStorage();
17/04/02 18:24:00 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
11556675 [main] INFO  org.apache.pig.tools.pigstats.ScriptState  - Pig features used in the script: HASH_JOIN,DISTINCT,FILTER
17/04/02 18:24:00 INFO pigstats.ScriptState: Pig features used in the script: HASH_JOIN,DISTINCT,FILTER
17/04/02 18:24:00 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
11556711 [main] INFO  org.apache.pig.data.SchemaTupleBackend  - Key [pig.schematuple] was not set... will not generate code.
17/04/02 18:24:00 INFO data.SchemaTupleBackend: Key [pig.schematuple] was not set... will not generate code.
11556712 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer  - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 18:24:00 INFO optimizer.LogicalPlanOptimizer: {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 18:24:00 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
11556744 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
17/04/02 18:24:00 INFO tez.TezLauncher: Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
11556744 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler  - File concatenation threshold: 100 optimistic? false
17/04/02 18:24:00 INFO plan.TezCompiler: File concatenation threshold: 100 optimistic? false
11556758 [main] INFO  org.apache.pig.builtin.TextLoader  - Using PigTextInputFormat
17/04/02 18:24:00 INFO builtin.TextLoader: Using PigTextInputFormat
17/04/02 18:24:00 INFO input.FileInputFormat: Total input paths to process : 1
11556849 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths to process : 1
17/04/02 18:24:00 INFO util.MapRedUtil: Total input paths to process : 1
11556850 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths (combined) to process : 1
17/04/02 18:24:00 INFO util.MapRedUtil: Total input paths (combined) to process : 1
17/04/02 18:24:00 INFO hadoop.MRInputHelpers: NumSplits: 1, SerializedSize: 389
11556862 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: myudfs.jar
17/04/02 18:24:00 INFO tez.TezJobCompiler: Local resource: myudfs.jar
11556862 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: pig-0.16.0-amzn-0-core-h2.jar
17/04/02 18:24:00 INFO tez.TezJobCompiler: Local resource: pig-0.16.0-amzn-0-core-h2.jar
11556862 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: antlr-runtime-3.4.jar
17/04/02 18:24:00 INFO tez.TezJobCompiler: Local resource: antlr-runtime-3.4.jar
11556862 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: joda-time-2.8.1.jar
17/04/02 18:24:00 INFO tez.TezJobCompiler: Local resource: joda-time-2.8.1.jar
11556862 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: automaton-1.11-8.jar
17/04/02 18:24:00 INFO tez.TezJobCompiler: Local resource: automaton-1.11-8.jar
17/04/02 18:24:00 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
11556910 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-545: parallelism=1, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 18:24:00 INFO tez.TezDagBuilder: For vertex - scope-545: parallelism=1, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
11556910 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: filtered,filtered_copy,join_out,ntriples,raw
17/04/02 18:24:00 INFO tez.TezDagBuilder: Processing aliases: filtered,filtered_copy,join_out,ntriples,raw
11556910 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: raw[49,6],ntriples[-1,-1],filtered[51,11],join_out[53,11],filtered_copy[52,16],join_out[53,11]
17/04/02 18:24:00 INFO tez.TezDagBuilder: Detailed locations: raw[49,6],ntriples[-1,-1],filtered[51,11],join_out[53,11],filtered_copy[52,16],join_out[53,11]
11556910 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: MULTI_QUERY
17/04/02 18:24:00 INFO tez.TezDagBuilder: Pig features in the vertex: MULTI_QUERY
11556936 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Set auto parallelism for vertex scope-551
17/04/02 18:24:00 INFO tez.TezDagBuilder: Set auto parallelism for vertex scope-551
11556936 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-551: parallelism=1, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 18:24:00 INFO tez.TezDagBuilder: For vertex - scope-551: parallelism=1, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
11556936 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: join_out,join_out_dist
17/04/02 18:24:00 INFO tez.TezDagBuilder: Processing aliases: join_out,join_out_dist
11556936 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: join_out[53,11],join_out_dist[54,16]
17/04/02 18:24:00 INFO tez.TezDagBuilder: Detailed locations: join_out[53,11],join_out_dist[54,16]
11556936 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: HASH_JOIN
17/04/02 18:24:00 INFO tez.TezDagBuilder: Pig features in the vertex: HASH_JOIN
11556956 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Set auto parallelism for vertex scope-554
17/04/02 18:24:00 INFO tez.TezDagBuilder: Set auto parallelism for vertex scope-554
11556956 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-554: parallelism=9, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 18:24:00 INFO tez.TezDagBuilder: For vertex - scope-554: parallelism=9, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
11556956 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: 
17/04/02 18:24:00 INFO tez.TezDagBuilder: Processing aliases: 
11556956 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: 
17/04/02 18:24:00 INFO tez.TezDagBuilder: Detailed locations: 
11556956 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 18:24:00 INFO tez.TezDagBuilder: Pig features in the vertex: 
11556971 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Setting distinct combiner class between scope-551 and scope-554
17/04/02 18:24:00 INFO tez.TezDagBuilder: Setting distinct combiner class between scope-551 and scope-554
11556973 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Total estimated parallelism is 11
17/04/02 18:24:00 INFO tez.TezJobCompiler: Total estimated parallelism is 11
11557051 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState  - Pig script settings are added to the job
17/04/02 18:24:00 INFO tez.TezScriptState: Pig script settings are added to the job
17/04/02 18:24:00 INFO client.TezClient: Tez Client Version: [ component=tez-api, version=0.8.4, revision=30eccced8ce8c483445f0aa3175ce725831ff06b, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=2017-02-17T18:19:55Z ]
17/04/02 18:24:00 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 18:24:00 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
17/04/02 18:24:00 INFO client.TezClient: Using org.apache.tez.dag.history.ats.acls.ATSHistoryACLPolicyManager to manage Timeline ACLs
17/04/02 18:24:00 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 18:24:00 INFO client.TezClient: Session mode. Starting session.
17/04/02 18:24:00 INFO client.TezClientUtils: Using tez.lib.uris value from configuration: hdfs:///apps/tez/tez.tar.gz
17/04/02 18:24:00 INFO client.TezClientUtils: Using tez.lib.uris.classpath value from configuration: null
17/04/02 18:24:00 INFO client.TezClient: Tez system stage directory hdfs://ip-172-31-43-94.us-west-2.compute.internal:8020/tmp/temp458034843/.tez/application_1491115920200_0009 doesn't exist and is created
17/04/02 18:24:00 INFO acls.ATSHistoryACLPolicyManager: Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1491115920200_0009
17/04/02 18:24:00 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 18:24:01 INFO impl.YarnClientImpl: Submitted application application_1491115920200_0009
17/04/02 18:24:01 INFO client.TezClient: The url to track the Tez Session: http://ip-172-31-43-94.us-west-2.compute.internal:20888/proxy/application_1491115920200_0009/
11563925 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitting DAG PigLatin:DefaultJobName-0_scope-17
17/04/02 18:24:07 INFO tez.TezJob: Submitting DAG PigLatin:DefaultJobName-0_scope-17
17/04/02 18:24:07 INFO client.TezClient: Submitting dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0009, dagName=PigLatin:DefaultJobName-0_scope-17, callerContext={ context=PIG, callerType=PIG_SCRIPT_ID, callerId=PIG-default-ce74cf2a-ca84-4255-97af-b94147e40ad8 }
17/04/02 18:24:08 INFO client.TezClient: Submitted dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0009, dagName=PigLatin:DefaultJobName-0_scope-17
17/04/02 18:24:08 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 18:24:08 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
11564979 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitted DAG PigLatin:DefaultJobName-0_scope-17. Application id: application_1491115920200_0009
17/04/02 18:24:08 INFO tez.TezJob: Submitted DAG PigLatin:DefaultJobName-0_scope-17. Application id: application_1491115920200_0009
11565005 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - HadoopJobId: job_1491115920200_0009
17/04/02 18:24:08 INFO tez.TezLauncher: HadoopJobId: job_1491115920200_0009
11565981 [Timer-8] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 1 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 18:24:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 1 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
11582079 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=SUCCEEDED, progress=TotalTasks: 3 Succeeded: 3 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=Counters: 62
	org.apache.tez.common.counters.DAGCounter
		NUM_SUCCEEDED_TASKS=3
		TOTAL_LAUNCHED_TASKS=3
		RACK_LOCAL_TASKS=1
		AM_CPU_MILLISECONDS=3640
		AM_GC_TIME_MILLIS=47
	File System Counters
		FILE_BYTES_READ=492521
		FILE_BYTES_WRITTEN=154500
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=1251156
		HDFS_READ_OPS=3
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=2
		S3N_BYTES_READ=244662
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		REDUCE_INPUT_GROUPS=3332
		REDUCE_INPUT_RECORDS=4998
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=9996
		NUM_SHUFFLED_INPUTS=10
		NUM_SKIPPED_INPUTS=0
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=10
		GC_TIME_MILLIS=379
		CPU_MILLISECONDS=11250
		PHYSICAL_MEMORY_BYTES=1197998080
		VIRTUAL_MEMORY_BYTES=12148473856
		COMMITTED_HEAP_BYTES=1197998080
		INPUT_RECORDS_PROCESSED=1000
		INPUT_SPLIT_LENGTH_BYTES=244662
		OUTPUT_RECORDS=7996
		OUTPUT_BYTES=1748440
		OUTPUT_BYTES_WITH_OVERHEAD=1751116
		OUTPUT_BYTES_PHYSICAL=154244
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=154244
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=2
		SHUFFLE_BYTES=154244
		SHUFFLE_BYTES_DECOMPRESSED=1751116
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=154244
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=119
		MERGE_PHASE_TIME=156
		FIRST_EVENT_RECEIVED=66
		LAST_EVENT_RECEIVED=68
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=2998
		COMBINE_OUTPUT_RECORDS=2998
17/04/02 18:24:25 INFO tez.TezJob: DAG Status: status=SUCCEEDED, progress=TotalTasks: 3 Succeeded: 3 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=Counters: 62
	org.apache.tez.common.counters.DAGCounter
		NUM_SUCCEEDED_TASKS=3
		TOTAL_LAUNCHED_TASKS=3
		RACK_LOCAL_TASKS=1
		AM_CPU_MILLISECONDS=3640
		AM_GC_TIME_MILLIS=47
	File System Counters
		FILE_BYTES_READ=492521
		FILE_BYTES_WRITTEN=154500
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=1251156
		HDFS_READ_OPS=3
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=2
		S3N_BYTES_READ=244662
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		REDUCE_INPUT_GROUPS=3332
		REDUCE_INPUT_RECORDS=4998
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=9996
		NUM_SHUFFLED_INPUTS=10
		NUM_SKIPPED_INPUTS=0
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=10
		GC_TIME_MILLIS=379
		CPU_MILLISECONDS=11250
		PHYSICAL_MEMORY_BYTES=1197998080
		VIRTUAL_MEMORY_BYTES=12148473856
		COMMITTED_HEAP_BYTES=1197998080
		INPUT_RECORDS_PROCESSED=1000
		INPUT_SPLIT_LENGTH_BYTES=244662
		OUTPUT_RECORDS=7996
		OUTPUT_BYTES=1748440
		OUTPUT_BYTES_WITH_OVERHEAD=1751116
		OUTPUT_BYTES_PHYSICAL=154244
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=154244
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=2
		SHUFFLE_BYTES=154244
		SHUFFLE_BYTES_DECOMPRESSED=1751116
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=154244
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=119
		MERGE_PHASE_TIME=156
		FIRST_EVENT_RECEIVED=66
		LAST_EVENT_RECEIVED=68
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=2998
		COMBINE_OUTPUT_RECORDS=2998
17/04/02 18:24:25 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
11583009 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats  - Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 18:24:00                                                                                 
          FinishedAt: 2017-04-02 18:24:26                                                                                 
            Features: HASH_JOIN,DISTINCT,FILTER                                                                           

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-17                                                                  
                           ApplicationId: job_1491115920200_0009                                                                              
                      TotalLaunchedTasks: 3                                                                                                   
                           FileBytesRead: 492521                                                                                              
                        FileBytesWritten: 154500                                                                                              
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 1251156                                                                                             
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-545	->	Tez vertex scope-551,
Tez vertex scope-551	->	Tez vertex scope-554,
Tez vertex scope-554

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-545          1          1           1000                    0           2000             64            37844              0                0 filtered,filtered_copy,join_out,ntriples,raw	MULTI_QUERY	
scope-551          1          1              0                 2000           2998          38292           116656              0                0 join_out,join_out_dist	HASH_JOIN	
scope-554         -1          1              0                 2998           2998         454165                0              0          1251156 		/user/hadoop/example_3a_1,

Input(s):
Successfully read 1000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file"

Output(s):
Successfully stored 2998 records (1251156 bytes) in: "/user/hadoop/example_3a_1"

17/04/02 18:24:26 INFO tez.TezPigScriptStats: Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 18:24:00                                                                                 
          FinishedAt: 2017-04-02 18:24:26                                                                                 
            Features: HASH_JOIN,DISTINCT,FILTER                                                                           

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-17                                                                  
                           ApplicationId: job_1491115920200_0009                                                                              
                      TotalLaunchedTasks: 3                                                                                                   
                           FileBytesRead: 492521                                                                                              
                        FileBytesWritten: 154500                                                                                              
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 1251156                                                                                             
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-545	->	Tez vertex scope-551,
Tez vertex scope-551	->	Tez vertex scope-554,
Tez vertex scope-554

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-545          1          1           1000                    0           2000             64            37844              0                0 filtered,filtered_copy,join_out,ntriples,raw	MULTI_QUERY	
scope-551          1          1              0                 2000           2998          38292           116656              0                0 join_out,join_out_dist	HASH_JOIN	
scope-554         -1          1              0                 2998           2998         454165                0              0          1251156 		/user/hadoop/example_3a_1,

Input(s):
Successfully read 1000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file"

Output(s):
Successfully stored 2998 records (1251156 bytes) in: "/user/hadoop/example_3a_1"
