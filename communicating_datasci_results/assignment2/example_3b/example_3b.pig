-- Compute a Join

-- local IO-related library
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
-- raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader as (line:chararray);
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader as (line:chararray); 

-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);

-- filter the data to tuples whose subject matches
filtered = filter ntriples by (subject matches '.*rdfabout\\.com.*');

-- make another copy of the filtered collection
filtered_copy = foreach filtered generate $0 as subject2, $1 as predicate2, $2 as object2 PARALLEL 50;

-- join the two 
join_out = join filtered by object, filtered_copy by subject2;

-- distinct the join result
join_out_dist = distinct join_out;

-- store the results in the folder /user/hadoop/example_3b
store join_out_dist into '/user/hadoop/example_3b' using PigStorage();

============================================================================================================
grunt> store join_out_dist into '/user/hadoop/example_3b' using PigStorage();
17/04/02 18:13:40 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
10937229 [main] INFO  org.apache.pig.tools.pigstats.ScriptState  - Pig features used in the script: HASH_JOIN,DISTINCT,FILTER
17/04/02 18:13:40 INFO pigstats.ScriptState: Pig features used in the script: HASH_JOIN,DISTINCT,FILTER
17/04/02 18:13:40 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
10937259 [main] INFO  org.apache.pig.data.SchemaTupleBackend  - Key [pig.schematuple] was not set... will not generate code.
17/04/02 18:13:40 INFO data.SchemaTupleBackend: Key [pig.schematuple] was not set... will not generate code.
10937259 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer  - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 18:13:40 INFO optimizer.LogicalPlanOptimizer: {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 18:13:40 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
10937291 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
17/04/02 18:13:40 INFO tez.TezLauncher: Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
10937292 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler  - File concatenation threshold: 100 optimistic? false
17/04/02 18:13:40 INFO plan.TezCompiler: File concatenation threshold: 100 optimistic? false
10937319 [main] INFO  org.apache.pig.builtin.TextLoader  - Using PigTextInputFormat
17/04/02 18:13:40 INFO builtin.TextLoader: Using PigTextInputFormat
17/04/02 18:13:40 INFO input.FileInputFormat: Total input paths to process : 1
10937416 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths to process : 1
17/04/02 18:13:40 INFO util.MapRedUtil: Total input paths to process : 1
10937417 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths (combined) to process : 33
17/04/02 18:13:40 INFO util.MapRedUtil: Total input paths (combined) to process : 33
17/04/02 18:13:40 INFO hadoop.MRInputHelpers: NumSplits: 33, SerializedSize: 12903
10937429 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: myudfs.jar
17/04/02 18:13:40 INFO tez.TezJobCompiler: Local resource: myudfs.jar
10937429 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: pig-0.16.0-amzn-0-core-h2.jar
17/04/02 18:13:40 INFO tez.TezJobCompiler: Local resource: pig-0.16.0-amzn-0-core-h2.jar
10937429 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: antlr-runtime-3.4.jar
17/04/02 18:13:40 INFO tez.TezJobCompiler: Local resource: antlr-runtime-3.4.jar
10937429 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: joda-time-2.8.1.jar
17/04/02 18:13:40 INFO tez.TezJobCompiler: Local resource: joda-time-2.8.1.jar
10937429 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: automaton-1.11-8.jar
17/04/02 18:13:40 INFO tez.TezJobCompiler: Local resource: automaton-1.11-8.jar
17/04/02 18:13:41 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
10937484 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-496: parallelism=33, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 18:13:41 INFO tez.TezDagBuilder: For vertex - scope-496: parallelism=33, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
10937484 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: filtered,filtered_copy,join_out,ntriples,raw
17/04/02 18:13:41 INFO tez.TezDagBuilder: Processing aliases: filtered,filtered_copy,join_out,ntriples,raw
10937484 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: raw[42,6],ntriples[-1,-1],filtered[44,11],join_out[46,11],filtered_copy[45,16],join_out[46,11]
17/04/02 18:13:41 INFO tez.TezDagBuilder: Detailed locations: raw[42,6],ntriples[-1,-1],filtered[44,11],join_out[46,11],filtered_copy[45,16],join_out[46,11]
10937484 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: MULTI_QUERY
17/04/02 18:13:41 INFO tez.TezDagBuilder: Pig features in the vertex: MULTI_QUERY
10937512 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Set auto parallelism for vertex scope-502
17/04/02 18:13:41 INFO tez.TezDagBuilder: Set auto parallelism for vertex scope-502
10937512 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-502: parallelism=24, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 18:13:41 INFO tez.TezDagBuilder: For vertex - scope-502: parallelism=24, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
10937512 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: join_out,join_out_dist
17/04/02 18:13:41 INFO tez.TezDagBuilder: Processing aliases: join_out,join_out_dist
10937512 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: join_out[46,11],join_out_dist[47,16]
17/04/02 18:13:41 INFO tez.TezDagBuilder: Detailed locations: join_out[46,11],join_out_dist[47,16]
10937512 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: HASH_JOIN
17/04/02 18:13:41 INFO tez.TezDagBuilder: Pig features in the vertex: HASH_JOIN
10937539 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Set auto parallelism for vertex scope-505
17/04/02 18:13:41 INFO tez.TezDagBuilder: Set auto parallelism for vertex scope-505
10937539 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-505: parallelism=216, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 18:13:41 INFO tez.TezDagBuilder: For vertex - scope-505: parallelism=216, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
10937540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: 
17/04/02 18:13:41 INFO tez.TezDagBuilder: Processing aliases: 
10937540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: 
17/04/02 18:13:41 INFO tez.TezDagBuilder: Detailed locations: 
10937540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 18:13:41 INFO tez.TezDagBuilder: Pig features in the vertex: 
10937557 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Setting distinct combiner class between scope-502 and scope-505
17/04/02 18:13:41 INFO tez.TezDagBuilder: Setting distinct combiner class between scope-502 and scope-505
10937559 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Total estimated parallelism is 273
17/04/02 18:13:41 INFO tez.TezJobCompiler: Total estimated parallelism is 273
10937606 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState  - Pig script settings are added to the job
17/04/02 18:13:41 INFO tez.TezScriptState: Pig script settings are added to the job
17/04/02 18:13:41 INFO client.TezClient: Tez Client Version: [ component=tez-api, version=0.8.4, revision=30eccced8ce8c483445f0aa3175ce725831ff06b, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=2017-02-17T18:19:55Z ]
17/04/02 18:13:41 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 18:13:41 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
17/04/02 18:13:41 INFO client.TezClient: Using org.apache.tez.dag.history.ats.acls.ATSHistoryACLPolicyManager to manage Timeline ACLs
17/04/02 18:13:41 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 18:13:41 INFO client.TezClient: Session mode. Starting session.
17/04/02 18:13:41 INFO client.TezClientUtils: Using tez.lib.uris value from configuration: hdfs:///apps/tez/tez.tar.gz
17/04/02 18:13:41 INFO client.TezClientUtils: Using tez.lib.uris.classpath value from configuration: null
17/04/02 18:13:41 INFO client.TezClient: Tez system stage directory hdfs://ip-172-31-43-94.us-west-2.compute.internal:8020/tmp/temp458034843/.tez/application_1491115920200_0008 doesn't exist and is created
17/04/02 18:13:41 INFO acls.ATSHistoryACLPolicyManager: Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1491115920200_0008
17/04/02 18:13:41 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 18:13:41 INFO impl.YarnClientImpl: Submitted application application_1491115920200_0008
17/04/02 18:13:41 INFO client.TezClient: The url to track the Tez Session: http://ip-172-31-43-94.us-west-2.compute.internal:20888/proxy/application_1491115920200_0008/
10943492 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitting DAG PigLatin:DefaultJobName-0_scope-15
17/04/02 18:13:47 INFO tez.TezJob: Submitting DAG PigLatin:DefaultJobName-0_scope-15
17/04/02 18:13:47 INFO client.TezClient: Submitting dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0008, dagName=PigLatin:DefaultJobName-0_scope-15, callerContext={ context=PIG, callerType=PIG_SCRIPT_ID, callerId=PIG-default-ce74cf2a-ca84-4255-97af-b94147e40ad8 }
17/04/02 18:13:47 INFO client.TezClient: Submitted dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0008, dagName=PigLatin:DefaultJobName-0_scope-15
17/04/02 18:13:48 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 18:13:48 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
10944964 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitted DAG PigLatin:DefaultJobName-0_scope-15. Application id: application_1491115920200_0008
17/04/02 18:13:48 INFO tez.TezJob: Submitted DAG PigLatin:DefaultJobName-0_scope-15. Application id: application_1491115920200_0008
10944967 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - HadoopJobId: job_1491115920200_0008
17/04/02 18:13:48 INFO tez.TezLauncher: HadoopJobId: job_1491115920200_0008
10945968 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 18:13:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
10965968 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 0 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 18:14:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 0 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
10985968 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 5 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 1, diagnostics=, counters=null
17/04/02 18:14:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 5 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 1, diagnostics=, counters=null
11005969 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 10 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 1, diagnostics=, counters=null
17/04/02 18:14:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 10 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 1, diagnostics=, counters=null
11025969 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 16 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 3, diagnostics=, counters=null
17/04/02 18:15:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 16 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 3, diagnostics=, counters=null
11045969 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 22 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 4 KilledTaskAttempts: 4, diagnostics=, counters=null
17/04/02 18:15:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 22 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 4 KilledTaskAttempts: 4, diagnostics=, counters=null
11065970 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 30 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 5, diagnostics=, counters=null
17/04/02 18:15:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 30 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 5, diagnostics=, counters=null
11086315 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 32 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 5, diagnostics=, counters=null
17/04/02 18:16:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 56 Succeeded: 32 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 5, diagnostics=, counters=null
11147017 [Timer-7] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 61 Succeeded: 33 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 7 KilledTaskAttempts: 6, diagnostics=, counters=null
17/04/02 18:17:10 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 61 Succeeded: 33 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 7 KilledTaskAttempts: 6, diagnostics=, counters=null
11154342 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=SUCCEEDED, progress=TotalTasks: 35 Succeeded: 35 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 7 KilledTaskAttempts: 6, diagnostics=, counters=Counters: 65
	org.apache.tez.common.counters.DAGCounter
		NUM_FAILED_TASKS=7
		NUM_KILLED_TASKS=6
		NUM_SUCCEEDED_TASKS=35
		TOTAL_LAUNCHED_TASKS=42
		RACK_LOCAL_TASKS=33
		AM_CPU_MILLISECONDS=9690
		AM_GC_TIME_MILLIS=33
	File System Counters
		FILE_BYTES_READ=24503375
		FILE_BYTES_WRITTEN=4488181
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=13082183
		HDFS_READ_OPS=3
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=2
		S3N_BYTES_READ=2211541840
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=9
		REDUCE_INPUT_GROUPS=44485
		REDUCE_INPUT_RECORDS=75173
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=187342
		NUM_SHUFFLED_INPUTS=802
		NUM_SKIPPED_INPUTS=17
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=76182
		GC_TIME_MILLIS=12291
		CPU_MILLISECONDS=155360
		PHYSICAL_MEMORY_BYTES=32932102144
		VIRTUAL_MEMORY_BYTES=113792282624
		COMMITTED_HEAP_BYTES=32932102144
		INPUT_RECORDS_PROCESSED=10000000
		INPUT_SPLIT_LENGTH_BYTES=2211121475
		OUTPUT_RECORDS=120417
		OUTPUT_BYTES=31858319
		OUTPUT_BYTES_WITH_OVERHEAD=23583520
		OUTPUT_BYTES_PHYSICAL=3304157
		ADDITIONAL_SPILLS_BYTES_WRITTEN=47604
		ADDITIONAL_SPILLS_BYTES_READ=4392486
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=34
		SHUFFLE_BYTES=3303817
		SHUFFLE_BYTES_DECOMPRESSED=23583418
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=3303817
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=1
		SHUFFLE_PHASE_TIME=1026
		MERGE_PHASE_TIME=1501
		FIRST_EVENT_RECEIVED=91
		LAST_EVENT_RECEIVED=596
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=28461
		COMBINE_OUTPUT_RECORDS=45244
17/04/02 18:17:17 INFO tez.TezJob: DAG Status: status=SUCCEEDED, progress=TotalTasks: 35 Succeeded: 35 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 7 KilledTaskAttempts: 6, diagnostics=, counters=Counters: 65
	org.apache.tez.common.counters.DAGCounter
		NUM_FAILED_TASKS=7
		NUM_KILLED_TASKS=6
		NUM_SUCCEEDED_TASKS=35
		TOTAL_LAUNCHED_TASKS=42
		RACK_LOCAL_TASKS=33
		AM_CPU_MILLISECONDS=9690
		AM_GC_TIME_MILLIS=33
	File System Counters
		FILE_BYTES_READ=24503375
		FILE_BYTES_WRITTEN=4488181
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=13082183
		HDFS_READ_OPS=3
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=2
		S3N_BYTES_READ=2211541840
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=9
		REDUCE_INPUT_GROUPS=44485
		REDUCE_INPUT_RECORDS=75173
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=187342
		NUM_SHUFFLED_INPUTS=802
		NUM_SKIPPED_INPUTS=17
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=76182
		GC_TIME_MILLIS=12291
		CPU_MILLISECONDS=155360
		PHYSICAL_MEMORY_BYTES=32932102144
		VIRTUAL_MEMORY_BYTES=113792282624
		COMMITTED_HEAP_BYTES=32932102144
		INPUT_RECORDS_PROCESSED=10000000
		INPUT_SPLIT_LENGTH_BYTES=2211121475
		OUTPUT_RECORDS=120417
		OUTPUT_BYTES=31858319
		OUTPUT_BYTES_WITH_OVERHEAD=23583520
		OUTPUT_BYTES_PHYSICAL=3304157
		ADDITIONAL_SPILLS_BYTES_WRITTEN=47604
		ADDITIONAL_SPILLS_BYTES_READ=4392486
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=34
		SHUFFLE_BYTES=3303817
		SHUFFLE_BYTES_DECOMPRESSED=23583418
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=3303817
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=1
		SHUFFLE_PHASE_TIME=1026
		MERGE_PHASE_TIME=1501
		FIRST_EVENT_RECEIVED=91
		LAST_EVENT_RECEIVED=596
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=28461
		COMBINE_OUTPUT_RECORDS=45244
17/04/02 18:17:17 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
11154875 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats  - Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 18:13:40                                                                                 
          FinishedAt: 2017-04-02 18:17:18                                                                                 
            Features: HASH_JOIN,DISTINCT,FILTER                                                                           

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-15                                                                  
                           ApplicationId: job_1491115920200_0008                                                                              
                      TotalLaunchedTasks: 42                                                                                                  
                           FileBytesRead: 24503375                                                                                            
                        FileBytesWritten: 4488181                                                                                             
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 13082183                                                                                            
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-496	->	Tez vertex scope-502,
Tez vertex scope-502	->	Tez vertex scope-505,
Tez vertex scope-505

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-496         33         33       10000000                    0          46712          38544          1888239              0                0 filtered,filtered_copy,join_out,ntriples,raw	MULTI_QUERY	
scope-502         24          1              0                46712          45244       22689669          2599942              0                0 join_out,join_out_dist	HASH_JOIN	
scope-505         -1          1              0                28461          28461        1775162                0              0         13082183 		/user/hadoop/example_3b,

Input(s):
Successfully read 10000000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000"

Output(s):
Successfully stored 28461 records (13082183 bytes) in: "/user/hadoop/example_3b"

17/04/02 18:17:18 INFO tez.TezPigScriptStats: Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 18:13:40                                                                                 
          FinishedAt: 2017-04-02 18:17:18                                                                                 
            Features: HASH_JOIN,DISTINCT,FILTER                                                                           

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-15                                                                  
                           ApplicationId: job_1491115920200_0008                                                                              
                      TotalLaunchedTasks: 42                                                                                                  
                           FileBytesRead: 24503375                                                                                            
                        FileBytesWritten: 4488181                                                                                             
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 13082183                                                                                            
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-496	->	Tez vertex scope-502,
Tez vertex scope-502	->	Tez vertex scope-505,
Tez vertex scope-505

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-496         33         33       10000000                    0          46712          38544          1888239              0                0 filtered,filtered_copy,join_out,ntriples,raw	MULTI_QUERY	
scope-502         24          1              0                46712          45244       22689669          2599942              0                0 join_out,join_out_dist	HASH_JOIN	
scope-505         -1          1              0                28461          28461        1775162                0              0         13082183 		/user/hadoop/example_3b,

Input(s):
Successfully read 10000000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000"

Output(s):
Successfully stored 28461 records (13082183 bytes) in: "/user/hadoop/example_3b"

grunt> 
