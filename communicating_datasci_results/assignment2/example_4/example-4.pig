-- Compute a Histogram with ~0.5TB dataset

-- local IO-related library
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-*' USING TextLoader as (line:chararray);

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

-- store the results in the folder /user/hadoop/example_6
store count_by_count into '/user/hadoop/example_6' using PigStorage();

==========================================================================
grunt> store count_by_count into '/user/hadoop/example_4' using PigStorage();
17/04/02 19:30:34 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 19:30:34 INFO Configuration.deprecation: mapred.textoutputformat.separator is deprecated. Instead, use mapreduce.output.textoutputformat.separator
66092 [main] INFO  org.apache.pig.tools.pigstats.ScriptState  - Pig features used in the script: GROUP_BY
17/04/02 19:30:34 INFO pigstats.ScriptState: Pig features used in the script: GROUP_BY
17/04/02 19:30:34 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
66145 [main] INFO  org.apache.pig.data.SchemaTupleBackend  - Key [pig.schematuple] was not set... will not generate code.
17/04/02 19:30:34 INFO data.SchemaTupleBackend: Key [pig.schematuple] was not set... will not generate code.
66186 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer  - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 19:30:34 INFO optimizer.LogicalPlanOptimizer: {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
66272 [main] INFO  org.apache.pig.impl.util.SpillableMemoryManager  - Selected heap (PS Old Gen) of size 699400192 to monitor. collectionUsageThreshold = 489580128, usageThreshold = 489580128
17/04/02 19:30:35 INFO util.SpillableMemoryManager: Selected heap (PS Old Gen) of size 699400192 to monitor. collectionUsageThreshold = 489580128, usageThreshold = 489580128
17/04/02 19:30:35 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
66383 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - Tez staging directory is /tmp/temp-955921689 and resources directory is /tmp/temp-955921689
17/04/02 19:30:35 INFO tez.TezLauncher: Tez staging directory is /tmp/temp-955921689 and resources directory is /tmp/temp-955921689
66437 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler  - File concatenation threshold: 100 optimistic? false
17/04/02 19:30:35 INFO plan.TezCompiler: File concatenation threshold: 100 optimistic? false
66485 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 19:30:35 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
66489 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 19:30:35 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
17/04/02 19:30:35 INFO Configuration.deprecation: mapreduce.inputformat.class is deprecated. Instead, use mapreduce.job.inputformat.class
66598 [main] INFO  org.apache.pig.builtin.TextLoader  - Using PigTextInputFormat
17/04/02 19:30:35 INFO builtin.TextLoader: Using PigTextInputFormat
17/04/02 19:30:35 INFO input.FileInputFormat: Total input paths to process : 251
66888 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths to process : 251
17/04/02 19:30:35 INFO util.MapRedUtil: Total input paths to process : 251
17/04/02 19:30:35 INFO lzo.GPLNativeCodeLoader: Loaded native gpl library
17/04/02 19:30:35 INFO lzo.LzoCodec: Successfully loaded & initialized native-lzo library [hadoop-lzo rev 30eccced8ce8c483445f0aa3175ce725831ff06b]
67044 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths (combined) to process : 7908
17/04/02 19:30:35 INFO util.MapRedUtil: Total input paths (combined) to process : 7908
17/04/02 19:30:36 INFO hadoop.MRInputHelpers: NumSplits: 7908, SerializedSize: 3100764
67662 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.optimizer.ParallelismSetter  - Increased requested parallelism of scope-28 to 100
17/04/02 19:30:36 INFO optimizer.ParallelismSetter: Increased requested parallelism of scope-28 to 100
68207 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: myudfs.jar
17/04/02 19:30:36 INFO tez.TezJobCompiler: Local resource: myudfs.jar
68215 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: pig-0.16.0-amzn-0-core-h2.jar
17/04/02 19:30:36 INFO tez.TezJobCompiler: Local resource: pig-0.16.0-amzn-0-core-h2.jar
68216 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: antlr-runtime-3.4.jar
17/04/02 19:30:36 INFO tez.TezJobCompiler: Local resource: antlr-runtime-3.4.jar
68216 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: joda-time-2.8.1.jar
17/04/02 19:30:36 INFO tez.TezJobCompiler: Local resource: joda-time-2.8.1.jar
68216 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: automaton-1.11-8.jar
17/04/02 19:30:36 INFO tez.TezJobCompiler: Local resource: automaton-1.11-8.jar
17/04/02 19:30:37 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 19:30:37 INFO Configuration.deprecation: mapred.output.compress is deprecated. Instead, use mapreduce.output.fileoutputformat.compress
17/04/02 19:30:37 INFO Configuration.deprecation: mapred.task.id is deprecated. Instead, use mapreduce.task.attempt.id
68501 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-27: parallelism=7908, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 19:30:37 INFO tez.TezDagBuilder: For vertex - scope-27: parallelism=7908, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
68502 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_subject,ntriples,raw,subjects
17/04/02 19:30:37 INFO tez.TezDagBuilder: Processing aliases: count_by_subject,ntriples,raw,subjects
68502 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: raw[1,6],ntriples[-1,-1],count_by_subject[4,19],subjects[3,11]
17/04/02 19:30:37 INFO tez.TezDagBuilder: Detailed locations: raw[1,6],ntriples[-1,-1],count_by_subject[4,19],subjects[3,11]
68502 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 19:30:37 INFO tez.TezDagBuilder: Pig features in the vertex: 
68908 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-28: parallelism=100, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 19:30:37 INFO tez.TezDagBuilder: For vertex - scope-28: parallelism=100, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
68910 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_count,count_by_subject,group_by_count
17/04/02 19:30:37 INFO tez.TezDagBuilder: Processing aliases: count_by_count,count_by_subject,group_by_count
68911 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_subject[4,19],count_by_count[6,17],group_by_count[5,17]
17/04/02 19:30:37 INFO tez.TezDagBuilder: Detailed locations: count_by_subject[4,19],count_by_count[6,17],group_by_count[5,17]
68911 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY
17/04/02 19:30:37 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY
69001 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-29: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 19:30:37 INFO tez.TezDagBuilder: For vertex - scope-29: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
69001 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_count
17/04/02 19:30:37 INFO tez.TezDagBuilder: Processing aliases: count_by_count
69001 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_count[6,17]
17/04/02 19:30:37 INFO tez.TezDagBuilder: Detailed locations: count_by_count[6,17]
69006 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY
17/04/02 19:30:37 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY
69061 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Total estimated parallelism is 8058
17/04/02 19:30:37 INFO tez.TezJobCompiler: Total estimated parallelism is 8058
69165 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState  - Pig script settings are added to the job
17/04/02 19:30:37 INFO tez.TezScriptState: Pig script settings are added to the job
17/04/02 19:30:37 INFO client.TezClient: Tez Client Version: [ component=tez-api, version=0.8.4, revision=30eccced8ce8c483445f0aa3175ce725831ff06b, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=2017-02-17T18:19:55Z ]
17/04/02 19:30:38 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-26-202.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 19:30:38 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-26-202.us-west-2.compute.internal/172.31.26.202:8032
17/04/02 19:30:38 INFO client.TezClient: Using org.apache.tez.dag.history.ats.acls.ATSHistoryACLPolicyManager to manage Timeline ACLs
17/04/02 19:30:38 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-26-202.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 19:30:38 INFO client.TezClient: Session mode. Starting session.
17/04/02 19:30:38 INFO client.TezClientUtils: Using tez.lib.uris value from configuration: hdfs:///apps/tez/tez.tar.gz
17/04/02 19:30:38 INFO client.TezClientUtils: Using tez.lib.uris.classpath value from configuration: null
17/04/02 19:30:38 INFO client.TezClient: Tez system stage directory hdfs://ip-172-31-26-202.us-west-2.compute.internal:8020/tmp/temp-955921689/.tez/application_1491160762487_0001 doesn't exist and is created
17/04/02 19:30:38 INFO acls.ATSHistoryACLPolicyManager: Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1491160762487_0001
17/04/02 19:30:38 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 19:30:39 INFO impl.YarnClientImpl: Submitted application application_1491160762487_0001
17/04/02 19:30:39 INFO client.TezClient: The url to track the Tez Session: http://ip-172-31-26-202.us-west-2.compute.internal:20888/proxy/application_1491160762487_0001/
77971 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitting DAG PigLatin:DefaultJobName-0_scope-0
17/04/02 19:30:46 INFO tez.TezJob: Submitting DAG PigLatin:DefaultJobName-0_scope-0
17/04/02 19:30:46 INFO client.TezClient: Submitting dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491160762487_0001, dagName=PigLatin:DefaultJobName-0_scope-0, callerContext={ context=PIG, callerType=PIG_SCRIPT_ID, callerId=PIG-default-7e7d5e9b-079d-4fa5-8703-bc3a7c7be551 }
17/04/02 19:30:47 INFO client.TezClient: Submitted dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491160762487_0001, dagName=PigLatin:DefaultJobName-0_scope-0
17/04/02 19:30:48 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-26-202.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 19:30:48 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-26-202.us-west-2.compute.internal/172.31.26.202:8032
79368 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitted DAG PigLatin:DefaultJobName-0_scope-0. Application id: application_1491160762487_0001
17/04/02 19:30:48 INFO tez.TezJob: Submitted DAG PigLatin:DefaultJobName-0_scope-0. Application id: application_1491160762487_0001
80118 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - HadoopJobId: job_1491160762487_0001
17/04/02 19:30:48 INFO tez.TezLauncher: HadoopJobId: job_1491160762487_0001
80375 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:30:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
100375 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 0 Running: 13 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:31:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 0 Running: 13 Failed: 0 Killed: 0, diagnostics=, counters=null
120375 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 27 Running: 29 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:31:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 27 Running: 29 Failed: 0 Killed: 0, diagnostics=, counters=null
140376 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 93 Running: 44 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:31:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 93 Running: 44 Failed: 0 Killed: 0, diagnostics=, counters=null
160376 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 173 Running: 53 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:32:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 173 Running: 53 Failed: 0 Killed: 0, diagnostics=, counters=null
180376 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 264 Running: 62 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:32:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 264 Running: 62 Failed: 0 Killed: 0, diagnostics=, counters=null
200377 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 376 Running: 66 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 19:32:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 376 Running: 66 Failed: 0 Killed: 0, diagnostics=, counters=null
220377 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 510 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 2, diagnostics=, counters=null
17/04/02 19:33:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 510 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 2, diagnostics=, counters=null
240377 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 652 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 2, diagnostics=, counters=null
17/04/02 19:33:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 652 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 2, diagnostics=, counters=null
260378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 797 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 4, diagnostics=, counters=null
17/04/02 19:33:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 797 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 4, diagnostics=, counters=null
280378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 947 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 6, diagnostics=, counters=null
17/04/02 19:34:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 947 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 6, diagnostics=, counters=null
300378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1088 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 7, diagnostics=, counters=null
17/04/02 19:34:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1088 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 7, diagnostics=, counters=null
320378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1237 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 8, diagnostics=, counters=null
17/04/02 19:34:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1237 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 8, diagnostics=, counters=null
340378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1388 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 10, diagnostics=, counters=null
17/04/02 19:35:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1388 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 10, diagnostics=, counters=null
360378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1543 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 11, diagnostics=, counters=null
17/04/02 19:35:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1543 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 11, diagnostics=, counters=null
380378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1700 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 12, diagnostics=, counters=null
17/04/02 19:35:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1700 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 12, diagnostics=, counters=null
400378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1851 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 14, diagnostics=, counters=null
17/04/02 19:36:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 1851 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 14, diagnostics=, counters=null
420378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2001 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 15, diagnostics=, counters=null
17/04/02 19:36:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2001 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 15, diagnostics=, counters=null
440378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2159 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 16, diagnostics=, counters=null
17/04/02 19:36:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2159 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 16, diagnostics=, counters=null
460378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2320 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 18, diagnostics=, counters=null
17/04/02 19:37:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2320 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 18, diagnostics=, counters=null
480379 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2482 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 19, diagnostics=, counters=null
17/04/02 19:37:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2482 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 19, diagnostics=, counters=null
500378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2634 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 20, diagnostics=, counters=null
17/04/02 19:37:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2634 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 20, diagnostics=, counters=null
520378 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2782 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 22, diagnostics=, counters=null
17/04/02 19:38:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2782 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 22, diagnostics=, counters=null
540379 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2947 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 23, diagnostics=, counters=null
17/04/02 19:38:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 2947 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 23, diagnostics=, counters=null
560379 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3111 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 23, diagnostics=, counters=null
17/04/02 19:38:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3111 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 23, diagnostics=, counters=null
580379 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3267 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 25, diagnostics=, counters=null
17/04/02 19:39:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3267 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 25, diagnostics=, counters=null
600380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3423 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 26, diagnostics=, counters=null
17/04/02 19:39:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3423 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 26, diagnostics=, counters=null
620380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3584 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 27, diagnostics=, counters=null
17/04/02 19:39:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3584 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 27, diagnostics=, counters=null
640380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3738 Running: 69 Failed: 0 Killed: 0 KilledTaskAttempts: 29, diagnostics=, counters=null
17/04/02 19:40:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3738 Running: 69 Failed: 0 Killed: 0 KilledTaskAttempts: 29, diagnostics=, counters=null
660380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3896 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 30, diagnostics=, counters=null
17/04/02 19:40:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 3896 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 30, diagnostics=, counters=null
680380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4049 Running: 70 Failed: 0 Killed: 0 KilledTaskAttempts: 31, diagnostics=, counters=null
17/04/02 19:40:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4049 Running: 70 Failed: 0 Killed: 0 KilledTaskAttempts: 31, diagnostics=, counters=null
700380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4199 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 33, diagnostics=, counters=null
17/04/02 19:41:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4199 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 33, diagnostics=, counters=null
720380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4360 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 34, diagnostics=, counters=null
17/04/02 19:41:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4360 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 34, diagnostics=, counters=null
740380 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4522 Running: 63 Failed: 0 Killed: 0 KilledTaskAttempts: 35, diagnostics=, counters=null
17/04/02 19:41:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4522 Running: 63 Failed: 0 Killed: 0 KilledTaskAttempts: 35, diagnostics=, counters=null
760381 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4680 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 37, diagnostics=, counters=null
17/04/02 19:42:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4680 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 37, diagnostics=, counters=null
780381 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4839 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 38, diagnostics=, counters=null
17/04/02 19:42:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4839 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 38, diagnostics=, counters=null
800381 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4996 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 39, diagnostics=, counters=null
17/04/02 19:42:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 4996 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 39, diagnostics=, counters=null
820382 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5160 Running: 69 Failed: 0 Killed: 0 KilledTaskAttempts: 41, diagnostics=, counters=null
17/04/02 19:43:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5160 Running: 69 Failed: 0 Killed: 0 KilledTaskAttempts: 41, diagnostics=, counters=null
840382 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5323 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 42, diagnostics=, counters=null
17/04/02 19:43:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5323 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 42, diagnostics=, counters=null
860382 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5485 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 43, diagnostics=, counters=null
17/04/02 19:43:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5485 Running: 67 Failed: 0 Killed: 0 KilledTaskAttempts: 43, diagnostics=, counters=null
880383 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5646 Running: 62 Failed: 0 Killed: 0 KilledTaskAttempts: 45, diagnostics=, counters=null
17/04/02 19:44:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5646 Running: 62 Failed: 0 Killed: 0 KilledTaskAttempts: 45, diagnostics=, counters=null
900383 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5829 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 46, diagnostics=, counters=null
17/04/02 19:44:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5829 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 46, diagnostics=, counters=null
920383 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5978 Running: 70 Failed: 0 Killed: 0 KilledTaskAttempts: 47, diagnostics=, counters=null
17/04/02 19:44:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 5978 Running: 70 Failed: 0 Killed: 0 KilledTaskAttempts: 47, diagnostics=, counters=null
940384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6131 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 49, diagnostics=, counters=null
17/04/02 19:45:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6131 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 49, diagnostics=, counters=null
960384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6298 Running: 60 Failed: 0 Killed: 0 KilledTaskAttempts: 50, diagnostics=, counters=null
17/04/02 19:45:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6298 Running: 60 Failed: 0 Killed: 0 KilledTaskAttempts: 50, diagnostics=, counters=null
980384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6469 Running: 61 Failed: 0 Killed: 0 KilledTaskAttempts: 51, diagnostics=, counters=null
17/04/02 19:45:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6469 Running: 61 Failed: 0 Killed: 0 KilledTaskAttempts: 51, diagnostics=, counters=null
1000384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6624 Running: 69 Failed: 0 Killed: 0 KilledTaskAttempts: 53, diagnostics=, counters=null
17/04/02 19:46:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6624 Running: 69 Failed: 0 Killed: 0 KilledTaskAttempts: 53, diagnostics=, counters=null
1020384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6785 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 54, diagnostics=, counters=null
17/04/02 19:46:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6785 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 54, diagnostics=, counters=null
1040384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6949 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 55, diagnostics=, counters=null
17/04/02 19:46:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 6949 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 55, diagnostics=, counters=null
1060384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7125 Running: 59 Failed: 0 Killed: 0 KilledTaskAttempts: 57, diagnostics=, counters=null
17/04/02 19:47:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7125 Running: 59 Failed: 0 Killed: 0 KilledTaskAttempts: 57, diagnostics=, counters=null
1080384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7284 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 58, diagnostics=, counters=null
17/04/02 19:47:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7284 Running: 66 Failed: 0 Killed: 0 KilledTaskAttempts: 58, diagnostics=, counters=null
1100384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7435 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 59, diagnostics=, counters=null
17/04/02 19:47:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7435 Running: 68 Failed: 0 Killed: 0 KilledTaskAttempts: 59, diagnostics=, counters=null
1120384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7589 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 61, diagnostics=, counters=null
17/04/02 19:48:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7589 Running: 65 Failed: 0 Killed: 0 KilledTaskAttempts: 61, diagnostics=, counters=null
1140384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7752 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 62, diagnostics=, counters=null
17/04/02 19:48:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7752 Running: 64 Failed: 0 Killed: 0 KilledTaskAttempts: 62, diagnostics=, counters=null
1160384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7908 Running: 16 Failed: 0 Killed: 0 KilledTaskAttempts: 63, diagnostics=, counters=null
17/04/02 19:48:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7908 Running: 16 Failed: 0 Killed: 0 KilledTaskAttempts: 63, diagnostics=, counters=null
1180384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7908 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 63, diagnostics=, counters=null
17/04/02 19:49:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7908 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 63, diagnostics=, counters=null
1200384 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7928 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 64, diagnostics=, counters=null
17/04/02 19:49:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7928 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 64, diagnostics=, counters=null
1220385 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7945 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 64, diagnostics=, counters=null
17/04/02 19:49:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7945 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 64, diagnostics=, counters=null
1240385 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7980 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 66, diagnostics=, counters=null
17/04/02 19:50:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 7980 Running: 35 Failed: 0 Killed: 0 KilledTaskAttempts: 66, diagnostics=, counters=null
1260385 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 8057 Running: 1 Failed: 0 Killed: 0 KilledTaskAttempts: 69, diagnostics=, counters=null
17/04/02 19:50:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 8058 Succeeded: 8057 Running: 1 Failed: 0 Killed: 0 KilledTaskAttempts: 69, diagnostics=, counters=null
17/04/02 19:50:31 INFO counters.Limits: Counter limits initialized with parameters:  GROUP_NAME_MAX=256, MAX_GROUPS=500, COUNTER_NAME_MAX=64, MAX_COUNTERS=120
1262279 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=SUCCEEDED, progress=TotalTasks: 8058 Succeeded: 8058 Running: 0 Failed: 0 Killed: 0 KilledTaskAttempts: 69, diagnostics=, counters=Counters: 64
	org.apache.tez.common.counters.DAGCounter
		NUM_KILLED_TASKS=69
		NUM_SUCCEEDED_TASKS=8058
		TOTAL_LAUNCHED_TASKS=8059
		RACK_LOCAL_TASKS=7908
		AM_CPU_MILLISECONDS=210170
		AM_GC_TIME_MILLIS=4596
	File System Counters
		FILE_BYTES_READ=5021528985
		FILE_BYTES_WRITTEN=9131126627
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=29467
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=530617858499
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=69
		REDUCE_INPUT_GROUPS=117696562
		REDUCE_INPUT_RECORDS=441976720
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=904740523
		NUM_SHUFFLED_INPUTS=795736
		NUM_SKIPPED_INPUTS=64
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=143060682
		GC_TIME_MILLIS=2364344
		CPU_MILLISECONDS=38571700
		PHYSICAL_MEMORY_BYTES=10121734782976
		VIRTUAL_MEMORY_BYTES=25820961181696
		COMMITTED_HEAP_BYTES=10121734782976
		INPUT_RECORDS_PROCESSED=2501793030
		INPUT_SPLIT_LENGTH_BYTES=530520369978
		OUTPUT_RECORDS=2619489592
		OUTPUT_BYTES=176322705417
		OUTPUT_BYTES_WITH_OVERHEAD=32704643827
		OUTPUT_BYTES_PHYSICAL=7024645952
		ADDITIONAL_SPILLS_BYTES_WRITTEN=77677525
		ADDITIONAL_SPILLS_BYTES_READ=2335493458
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=8008
		SHUFFLE_BYTES=7024644672
		SHUFFLE_BYTES_DECOMPRESSED=32704643443
		SHUFFLE_BYTES_TO_MEM=6634183281
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=390461391
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=434
		SHUFFLE_PHASE_TIME=696698
		MERGE_PHASE_TIME=1682871
		FIRST_EVENT_RECEIVED=12399
		LAST_EVENT_RECEIVED=549538
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=441976720
		COMBINE_OUTPUT_RECORDS=2619485610
17/04/02 19:50:31 INFO tez.TezJob: DAG Status: status=SUCCEEDED, progress=TotalTasks: 8058 Succeeded: 8058 Running: 0 Failed: 0 Killed: 0 KilledTaskAttempts: 69, diagnostics=, counters=Counters: 64
	org.apache.tez.common.counters.DAGCounter
		NUM_KILLED_TASKS=69
		NUM_SUCCEEDED_TASKS=8058
		TOTAL_LAUNCHED_TASKS=8059
		RACK_LOCAL_TASKS=7908
		AM_CPU_MILLISECONDS=210170
		AM_GC_TIME_MILLIS=4596
	File System Counters
		FILE_BYTES_READ=5021528985
		FILE_BYTES_WRITTEN=9131126627
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=29467
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=530617858499
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=69
		REDUCE_INPUT_GROUPS=117696562
		REDUCE_INPUT_RECORDS=441976720
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=904740523
		NUM_SHUFFLED_INPUTS=795736
		NUM_SKIPPED_INPUTS=64
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=143060682
		GC_TIME_MILLIS=2364344
		CPU_MILLISECONDS=38571700
		PHYSICAL_MEMORY_BYTES=10121734782976
		VIRTUAL_MEMORY_BYTES=25820961181696
		COMMITTED_HEAP_BYTES=10121734782976
		INPUT_RECORDS_PROCESSED=2501793030
		INPUT_SPLIT_LENGTH_BYTES=530520369978
		OUTPUT_RECORDS=2619489592
		OUTPUT_BYTES=176322705417
		OUTPUT_BYTES_WITH_OVERHEAD=32704643827
		OUTPUT_BYTES_PHYSICAL=7024645952
		ADDITIONAL_SPILLS_BYTES_WRITTEN=77677525
		ADDITIONAL_SPILLS_BYTES_READ=2335493458
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=8008
		SHUFFLE_BYTES=7024644672
		SHUFFLE_BYTES_DECOMPRESSED=32704643443
		SHUFFLE_BYTES_TO_MEM=6634183281
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=390461391
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=434
		SHUFFLE_PHASE_TIME=696698
		MERGE_PHASE_TIME=1682871
		FIRST_EVENT_RECEIVED=12399
		LAST_EVENT_RECEIVED=549538
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=441976720
		COMBINE_OUTPUT_RECORDS=2619485610
17/04/02 19:50:31 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
1263299 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats  - Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 19:30:35                                                                                 
          FinishedAt: 2017-04-02 19:50:32                                                                                 
            Features: GROUP_BY                                                                                            

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-0                                                                   
                           ApplicationId: job_1491160762487_0001                                                                              
                      TotalLaunchedTasks: 8059                                                                                                
                           FileBytesRead: 5021528985                                                                                          
                        FileBytesWritten: 9131126627                                                                                          
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 29467                                                                                               
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-27	->	Tez vertex scope-28,
Tez vertex scope-28	->	Tez vertex scope-29,
Tez vertex scope-29

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-27        7908       7908     2501793030                    0     2501793030       38084928       7042859520              0                0 count_by_subject,ntriples,raw,subjects		
scope-28         100        100              0            441897748      117692580     4981804637       2088097855              0                0 count_by_count,count_by_subject,group_by_count	GROUP_BY	
scope-29          50         50              0                78972           3982        1639420           169252              0            29467 count_by_count	GROUP_BY	/user/hadoop/example_4,

Input(s):
Successfully read 2501793030 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-*"

Output(s):
Successfully stored 3982 records (29467 bytes) in: "/user/hadoop/example_4"

17/04/02 19:50:32 INFO tez.TezPigScriptStats: Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 19:30:35                                                                                 
          FinishedAt: 2017-04-02 19:50:32                                                                                 
            Features: GROUP_BY                                                                                            

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-0                                                                   
                           ApplicationId: job_1491160762487_0001                                                                              
                      TotalLaunchedTasks: 8059                                                                                                
                           FileBytesRead: 5021528985                                                                                          
                        FileBytesWritten: 9131126627                                                                                          
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 29467                                                                                               
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-27	->	Tez vertex scope-28,
Tez vertex scope-28	->	Tez vertex scope-29,
Tez vertex scope-29

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-27        7908       7908     2501793030                    0     2501793030       38084928       7042859520              0                0 count_by_subject,ntriples,raw,subjects		
scope-28         100        100              0            441897748      117692580     4981804637       2088097855              0                0 count_by_count,count_by_subject,group_by_count	GROUP_BY	
scope-29          50         50              0                78972           3982        1639420           169252              0            29467 count_by_count	GROUP_BY	/user/hadoop/example_4,

Input(s):
Successfully read 2501793030 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-*"

Output(s):
Successfully stored 3982 records (29467 bytes) in: "/user/hadoop/example_4"

