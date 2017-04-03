-- data is represented as a set of triples of the form: subject predicate object [context]
-- 
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the file into Pig (2GB)
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader as (line:chararray);

-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);

--group the n-triples by object column
objects = group ntriples by (object) PARALLEL 50;

-- flatten the objects out (because group by produces a tuple of each object
-- in the first column, and we want each object ot be a string, not a tuple),
-- and count the number of tuples associated with each object
count_by_object = foreach objects generate flatten($0), COUNT($1) as count PARALLEL 50;

--order the resulting tuples by their count in descending order
count_by_object_ordered = order count_by_object by (count)  PARALLEL 50;

-- store the results in the folder /user/hadoop/example-results
store count_by_object_ordered into '/user/hadoop/example-results' using PigStorage();
-- Alternatively, you can store the results in S3, see instructions:
-- store count_by_object_ordered into 's3n://superman/example-results';

============================================================================
grunt> store count_by_object_ordered into '/user/hadoop/example-results' using PigStorage();
17/04/02 15:13:52 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 15:13:52 INFO Configuration.deprecation: mapred.textoutputformat.separator is deprecated. Instead, use mapreduce.output.textoutputformat.separator
149108 [main] INFO  org.apache.pig.tools.pigstats.ScriptState  - Pig features used in the script: GROUP_BY,ORDER_BY
17/04/02 15:13:52 INFO pigstats.ScriptState: Pig features used in the script: GROUP_BY,ORDER_BY
17/04/02 15:13:52 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
149163 [main] INFO  org.apache.pig.data.SchemaTupleBackend  - Key [pig.schematuple] was not set... will not generate code.
17/04/02 15:13:52 INFO data.SchemaTupleBackend: Key [pig.schematuple] was not set... will not generate code.
149205 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer  - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 15:13:52 INFO optimizer.LogicalPlanOptimizer: {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
149286 [main] INFO  org.apache.pig.impl.util.SpillableMemoryManager  - Selected heap (PS Old Gen) of size 699400192 to monitor. collectionUsageThreshold = 489580128, usageThreshold = 489580128
17/04/02 15:13:52 INFO util.SpillableMemoryManager: Selected heap (PS Old Gen) of size 699400192 to monitor. collectionUsageThreshold = 489580128, usageThreshold = 489580128
17/04/02 15:13:52 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
149398 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
17/04/02 15:13:52 INFO tez.TezLauncher: Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
149449 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler  - File concatenation threshold: 100 optimistic? false
17/04/02 15:13:53 INFO plan.TezCompiler: File concatenation threshold: 100 optimistic? false
149527 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 15:13:53 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
149540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.optimizer.SecondaryKeyOptimizerTez  - Using Secondary Key Optimization in the edge between vertex - scope-20 and vertex - scope-29
17/04/02 15:13:53 INFO optimizer.SecondaryKeyOptimizerTez: Using Secondary Key Optimization in the edge between vertex - scope-20 and vertex - scope-29
17/04/02 15:13:53 INFO Configuration.deprecation: mapreduce.inputformat.class is deprecated. Instead, use mapreduce.job.inputformat.class
149661 [main] INFO  org.apache.pig.builtin.TextLoader  - Using PigTextInputFormat
17/04/02 15:13:53 INFO builtin.TextLoader: Using PigTextInputFormat
17/04/02 15:13:53 INFO input.FileInputFormat: Total input paths to process : 1
149772 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths to process : 1
17/04/02 15:13:53 INFO util.MapRedUtil: Total input paths to process : 1
17/04/02 15:13:53 INFO lzo.GPLNativeCodeLoader: Loaded native gpl library
17/04/02 15:13:53 INFO lzo.LzoCodec: Successfully loaded & initialized native-lzo library [hadoop-lzo rev 30eccced8ce8c483445f0aa3175ce725831ff06b]
149809 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths (combined) to process : 33
17/04/02 15:13:53 INFO util.MapRedUtil: Total input paths (combined) to process : 33
17/04/02 15:13:53 INFO hadoop.MRInputHelpers: NumSplits: 33, SerializedSize: 12903
150493 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: myudfs.jar
17/04/02 15:13:54 INFO tez.TezJobCompiler: Local resource: myudfs.jar
150493 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: pig-0.16.0-amzn-0-core-h2.jar
17/04/02 15:13:54 INFO tez.TezJobCompiler: Local resource: pig-0.16.0-amzn-0-core-h2.jar
150493 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: antlr-runtime-3.4.jar
17/04/02 15:13:54 INFO tez.TezJobCompiler: Local resource: antlr-runtime-3.4.jar
150493 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: joda-time-2.8.1.jar
17/04/02 15:13:54 INFO tez.TezJobCompiler: Local resource: joda-time-2.8.1.jar
150493 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: automaton-1.11-8.jar
17/04/02 15:13:54 INFO tez.TezJobCompiler: Local resource: automaton-1.11-8.jar
17/04/02 15:13:54 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 15:13:54 INFO Configuration.deprecation: mapred.output.compress is deprecated. Instead, use mapreduce.output.fileoutputformat.compress
17/04/02 15:13:54 INFO Configuration.deprecation: mapred.task.id is deprecated. Instead, use mapreduce.task.attempt.id
150851 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-19: parallelism=33, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:13:54 INFO tez.TezDagBuilder: For vertex - scope-19: parallelism=33, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
150851 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_object,ntriples,objects,raw
17/04/02 15:13:54 INFO tez.TezDagBuilder: Processing aliases: count_by_object,ntriples,objects,raw
150851 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: raw[1,6],ntriples[-1,-1],count_by_object[4,18],objects[3,10]
17/04/02 15:13:54 INFO tez.TezDagBuilder: Detailed locations: raw[1,6],ntriples[-1,-1],count_by_object[4,18],objects[3,10]
150852 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Pig features in the vertex: 
150948 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-20: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:13:54 INFO tez.TezDagBuilder: For vertex - scope-20: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
150948 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_object,count_by_object_ordered
17/04/02 15:13:54 INFO tez.TezDagBuilder: Processing aliases: count_by_object,count_by_object_ordered
150948 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_object[4,18],count_by_object_ordered[5,26]
17/04/02 15:13:54 INFO tez.TezDagBuilder: Detailed locations: count_by_object[4,18],count_by_object_ordered[5,26]
150949 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY,SAMPLER
17/04/02 15:13:54 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY,SAMPLER
151057 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-29: parallelism=1, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:13:54 INFO tez.TezDagBuilder: For vertex - scope-29: parallelism=1, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
151057 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Processing aliases: 
151057 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Detailed locations: 
151057 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Pig features in the vertex: 
151085 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-39: parallelism=-1, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:13:54 INFO tez.TezDagBuilder: For vertex - scope-39: parallelism=-1, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
151086 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_object_ordered
17/04/02 15:13:54 INFO tez.TezDagBuilder: Processing aliases: count_by_object_ordered
151086 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_object_ordered[5,26]
17/04/02 15:13:54 INFO tez.TezDagBuilder: Detailed locations: count_by_object_ordered[5,26]
151086 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Pig features in the vertex: 
151121 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-41: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 15:13:54 INFO tez.TezDagBuilder: For vertex - scope-41: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
151122 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Processing aliases: 
151122 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: 
17/04/02 15:13:54 INFO tez.TezDagBuilder: Detailed locations: 
151122 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: ORDER_BY
17/04/02 15:13:54 INFO tez.TezDagBuilder: Pig features in the vertex: ORDER_BY
151166 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Total estimated parallelism is 184
17/04/02 15:13:54 INFO tez.TezJobCompiler: Total estimated parallelism is 184
151283 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState  - Pig script settings are added to the job
17/04/02 15:13:54 INFO tez.TezScriptState: Pig script settings are added to the job
17/04/02 15:13:54 INFO client.TezClient: Tez Client Version: [ component=tez-api, version=0.8.4, revision=30eccced8ce8c483445f0aa3175ce725831ff06b, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=2017-02-17T18:19:55Z ]
17/04/02 15:13:55 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 15:13:55 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
17/04/02 15:13:55 INFO client.TezClient: Using org.apache.tez.dag.history.ats.acls.ATSHistoryACLPolicyManager to manage Timeline ACLs
17/04/02 15:13:55 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 15:13:55 INFO client.TezClient: Session mode. Starting session.
17/04/02 15:13:55 INFO client.TezClientUtils: Using tez.lib.uris value from configuration: hdfs:///apps/tez/tez.tar.gz
17/04/02 15:13:55 INFO client.TezClientUtils: Using tez.lib.uris.classpath value from configuration: null
17/04/02 15:13:55 INFO client.TezClient: Tez system stage directory hdfs://ip-172-31-43-94.us-west-2.compute.internal:8020/tmp/temp458034843/.tez/application_1491115920200_0001 doesn't exist and is created
17/04/02 15:13:55 INFO acls.ATSHistoryACLPolicyManager: Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1491115920200_0001
17/04/02 15:13:55 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 15:13:56 INFO impl.YarnClientImpl: Submitted application application_1491115920200_0001
17/04/02 15:13:56 INFO client.TezClient: The url to track the Tez Session: http://ip-172-31-43-94.us-west-2.compute.internal:20888/proxy/application_1491115920200_0001/
163141 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitting DAG PigLatin:DefaultJobName-0_scope-0
17/04/02 15:14:06 INFO tez.TezJob: Submitting DAG PigLatin:DefaultJobName-0_scope-0
17/04/02 15:14:06 INFO client.TezClient: Submitting dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0001, dagName=PigLatin:DefaultJobName-0_scope-0, callerContext={ context=PIG, callerType=PIG_SCRIPT_ID, callerId=PIG-default-ce74cf2a-ca84-4255-97af-b94147e40ad8 }
17/04/02 15:14:06 INFO api.DAG: Inferring parallelism for vertex: scope-39 to be 50 from 1-1 connection with vertex scope-20
17/04/02 15:14:08 INFO client.TezClient: Submitted dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0001, dagName=PigLatin:DefaultJobName-0_scope-0
17/04/02 15:14:08 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 15:14:08 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
165326 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitted DAG PigLatin:DefaultJobName-0_scope-0. Application id: application_1491115920200_0001
17/04/02 15:14:08 INFO tez.TezJob: Submitted DAG PigLatin:DefaultJobName-0_scope-0. Application id: application_1491115920200_0001
166228 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - HadoopJobId: job_1491115920200_0001
17/04/02 15:14:09 INFO tez.TezLauncher: HadoopJobId: job_1491115920200_0001
166340 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 15:14:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
186340 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 0 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 15:14:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 0 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
206340 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 4 Running: 2 Failed: 0 Killed: 0 KilledTaskAttempts: 1, diagnostics=, counters=null
17/04/02 15:14:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 4 Running: 2 Failed: 0 Killed: 0 KilledTaskAttempts: 1, diagnostics=, counters=null
226341 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 12 Running: 2 Failed: 0 Killed: 0 KilledTaskAttempts: 3, diagnostics=, counters=null
17/04/02 15:15:09 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 12 Running: 2 Failed: 0 Killed: 0 KilledTaskAttempts: 3, diagnostics=, counters=null
246340 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 15 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 1 KilledTaskAttempts: 4, diagnostics=, counters=null
17/04/02 15:15:29 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 15 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 1 KilledTaskAttempts: 4, diagnostics=, counters=null
266340 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 21 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 2 KilledTaskAttempts: 5, diagnostics=, counters=null
17/04/02 15:15:49 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 21 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 2 KilledTaskAttempts: 5, diagnostics=, counters=null
287323 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 25 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 2 KilledTaskAttempts: 6, diagnostics=, counters=null
17/04/02 15:16:10 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 25 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 2 KilledTaskAttempts: 6, diagnostics=, counters=null
306500 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 26 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 2 KilledTaskAttempts: 7, diagnostics=, counters=null
17/04/02 15:16:30 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 26 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 2 KilledTaskAttempts: 7, diagnostics=, counters=null
326500 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 28 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 8, diagnostics=, counters=null
17/04/02 15:16:50 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 28 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 8, diagnostics=, counters=null
346500 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 32 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 9, diagnostics=, counters=null
17/04/02 15:17:10 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 32 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 9, diagnostics=, counters=null
366500 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 54 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 11, diagnostics=, counters=null
17/04/02 15:17:30 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 54 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 11, diagnostics=, counters=null
386500 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 131 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 13, diagnostics=, counters=null
17/04/02 15:17:50 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 131 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 13, diagnostics=, counters=null
406500 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 172 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 15, diagnostics=, counters=null
17/04/02 15:18:10 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 184 Succeeded: 172 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 15, diagnostics=, counters=null
17/04/02 15:18:15 INFO counters.Limits: Counter limits initialized with parameters:  GROUP_NAME_MAX=256, MAX_GROUPS=500, COUNTER_NAME_MAX=64, MAX_COUNTERS=120
411908 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=SUCCEEDED, progress=TotalTasks: 184 Succeeded: 184 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 15, diagnostics=, counters=Counters: 67
	org.apache.tez.common.counters.DAGCounter
		NUM_FAILED_TASKS=3
		NUM_KILLED_TASKS=15
		NUM_SUCCEEDED_TASKS=184
		TOTAL_LAUNCHED_TASKS=189
		OTHER_LOCAL_TASKS=50
		RACK_LOCAL_TASKS=33
		AM_CPU_MILLISECONDS=18500
		AM_GC_TIME_MILLIS=65
	File System Counters
		FILE_BYTES_READ=307454403
		FILE_BYTES_WRITTEN=139160387
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=89971068
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=2211528645
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=15
		REDUCE_INPUT_GROUPS=1623138
		REDUCE_INPUT_RECORDS=4884027
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=9826673
		NUM_SHUFFLED_INPUTS=4251
		NUM_SKIPPED_INPUTS=0
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=4200
		GC_TIME_MILLIS=13393
		CPU_MILLISECONDS=279630
		PHYSICAL_MEMORY_BYTES=269712621568
		VIRTUAL_MEMORY_BYTES=785756209152
		COMMITTED_HEAP_BYTES=269712621568
		INPUT_RECORDS_PROCESSED=11622295
		INPUT_SPLIT_LENGTH_BYTES=2211121475
		OUTPUT_RECORDS=14871883
		OUTPUT_LARGE_RECORDS=0
		OUTPUT_BYTES=769671982
		OUTPUT_BYTES_WITH_OVERHEAD=417233005
		OUTPUT_BYTES_PHYSICAL=137384999
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=103529852
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=133
		SHUFFLE_BYTES=137383775
		SHUFFLE_BYTES_DECOMPRESSED=417233005
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=137383775
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=5396
		MERGE_PHASE_TIME=6302
		FIRST_EVENT_RECEIVED=1639
		LAST_EVENT_RECEIVED=1831
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=3256733
		COMBINE_OUTPUT_RECORDS=10000000
17/04/02 15:18:15 INFO tez.TezJob: DAG Status: status=SUCCEEDED, progress=TotalTasks: 184 Succeeded: 184 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 15, diagnostics=, counters=Counters: 67
	org.apache.tez.common.counters.DAGCounter
		NUM_FAILED_TASKS=3
		NUM_KILLED_TASKS=15
		NUM_SUCCEEDED_TASKS=184
		TOTAL_LAUNCHED_TASKS=189
		OTHER_LOCAL_TASKS=50
		RACK_LOCAL_TASKS=33
		AM_CPU_MILLISECONDS=18500
		AM_GC_TIME_MILLIS=65
	File System Counters
		FILE_BYTES_READ=307454403
		FILE_BYTES_WRITTEN=139160387
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=89971068
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=2211528645
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=15
		REDUCE_INPUT_GROUPS=1623138
		REDUCE_INPUT_RECORDS=4884027
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=9826673
		NUM_SHUFFLED_INPUTS=4251
		NUM_SKIPPED_INPUTS=0
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=4200
		GC_TIME_MILLIS=13393
		CPU_MILLISECONDS=279630
		PHYSICAL_MEMORY_BYTES=269712621568
		VIRTUAL_MEMORY_BYTES=785756209152
		COMMITTED_HEAP_BYTES=269712621568
		INPUT_RECORDS_PROCESSED=11622295
		INPUT_SPLIT_LENGTH_BYTES=2211121475
		OUTPUT_RECORDS=14871883
		OUTPUT_LARGE_RECORDS=0
		OUTPUT_BYTES=769671982
		OUTPUT_BYTES_WITH_OVERHEAD=417233005
		OUTPUT_BYTES_PHYSICAL=137384999
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=103529852
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=133
		SHUFFLE_BYTES=137383775
		SHUFFLE_BYTES_DECOMPRESSED=417233005
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=137383775
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=5396
		MERGE_PHASE_TIME=6302
		FIRST_EVENT_RECEIVED=1639
		LAST_EVENT_RECEIVED=1831
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=3256733
		COMBINE_OUTPUT_RECORDS=10000000
17/04/02 15:18:15 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
412535 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats  - Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 15:13:53                                                                                 
          FinishedAt: 2017-04-02 15:18:16                                                                                 
            Features: GROUP_BY,ORDER_BY                                                                                   

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-0                                                                   
                           ApplicationId: job_1491115920200_0001                                                                              
                      TotalLaunchedTasks: 189                                                                                                 
                           FileBytesRead: 307454403                                                                                           
                        FileBytesWritten: 139160387                                                                                           
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 89971068                                                                                            
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-19	->	Tez vertex scope-20,
Tez vertex scope-20	->	Tez vertex scope-29,Tez vertex scope-39,
Tez vertex scope-29	->	Tez vertex scope-39,
Tez vertex scope-39	->	Tez vertex scope-41,
Tez vertex scope-41

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-19          33         33       10000000                    0       10000000          79728         59815300              0                0 count_by_object,ntriples,objects,raw		
scope-20          50         50              0              3256733        1627294      109813916         35549455              0                0 count_by_object,count_by_object_ordered	GROUP_BY,SAMPLER	
scope-29           1          1              0                 5000              1          21898             1114              0                0 		
scope-39          50         50        1622295                    0        1622294       35649471         42122149              0                0 count_by_object_ordered		
scope-41          50         50              0              1622294        1622294      161889390          1672369              0         89971068 	ORDER_BY	/user/hadoop/example-results,

Input(s):
Successfully read 10000000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000"

Output(s):
Successfully stored 1622294 records (89971068 bytes) in: "/user/hadoop/example-results"

17/04/02 15:18:16 INFO tez.TezPigScriptStats: Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 15:13:53                                                                                 
          FinishedAt: 2017-04-02 15:18:16                                                                                 
            Features: GROUP_BY,ORDER_BY                                                                                   

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-0                                                                   
                           ApplicationId: job_1491115920200_0001                                                                              
                      TotalLaunchedTasks: 189                                                                                                 
                           FileBytesRead: 307454403                                                                                           
                        FileBytesWritten: 139160387                                                                                           
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 89971068                                                                                            
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-19	->	Tez vertex scope-20,
Tez vertex scope-20	->	Tez vertex scope-29,Tez vertex scope-39,
Tez vertex scope-29	->	Tez vertex scope-39,
Tez vertex scope-39	->	Tez vertex scope-41,
Tez vertex scope-41

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-19          33         33       10000000                    0       10000000          79728         59815300              0                0 count_by_object,ntriples,objects,raw		
scope-20          50         50              0              3256733        1627294      109813916         35549455              0                0 count_by_object,count_by_object_ordered	GROUP_BY,SAMPLER	
scope-29           1          1              0                 5000              1          21898             1114              0                0 		
scope-39          50         50        1622295                    0        1622294       35649471         42122149              0                0 count_by_object_ordered		
scope-41          50         50              0              1622294        1622294      161889390          1672369              0         89971068 	ORDER_BY	/user/hadoop/example-results,

Input(s):
Successfully read 10000000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000"

Output(s):
Successfully stored 1622294 records (89971068 bytes) in: "/user/hadoop/example-results"
