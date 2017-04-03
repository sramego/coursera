-- Compute a Histogram

-- local IO-related library
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader as (line:chararray); 

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

=============================================================================================

grunt> store count_by_count into '/user/hadoop/example_2_b' using PigStorage();
17/04/02 17:34:51 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
8607480 [main] INFO  org.apache.pig.tools.pigstats.ScriptState  - Pig features used in the script: GROUP_BY
17/04/02 17:34:51 INFO pigstats.ScriptState: Pig features used in the script: GROUP_BY
17/04/02 17:34:51 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
8607512 [main] INFO  org.apache.pig.data.SchemaTupleBackend  - Key [pig.schematuple] was not set... will not generate code.
17/04/02 17:34:51 INFO data.SchemaTupleBackend: Key [pig.schematuple] was not set... will not generate code.
8607512 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer  - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 17:34:51 INFO optimizer.LogicalPlanOptimizer: {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
17/04/02 17:34:51 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
8607542 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
17/04/02 17:34:51 INFO tez.TezLauncher: Tez staging directory is /tmp/temp458034843 and resources directory is /tmp/temp458034843
8607542 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler  - File concatenation threshold: 100 optimistic? false
17/04/02 17:34:51 INFO plan.TezCompiler: File concatenation threshold: 100 optimistic? false
8607543 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 17:34:51 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
8607544 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.CombinerOptimizerUtil  - Choosing to move algebraic foreach to combiner
17/04/02 17:34:51 INFO util.CombinerOptimizerUtil: Choosing to move algebraic foreach to combiner
8607553 [main] INFO  org.apache.pig.builtin.TextLoader  - Using PigTextInputFormat
17/04/02 17:34:51 INFO builtin.TextLoader: Using PigTextInputFormat
17/04/02 17:34:51 INFO input.FileInputFormat: Total input paths to process : 1
8607946 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths to process : 1
17/04/02 17:34:51 INFO util.MapRedUtil: Total input paths to process : 1
8607947 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil  - Total input paths (combined) to process : 33
17/04/02 17:34:51 INFO util.MapRedUtil: Total input paths (combined) to process : 33
17/04/02 17:34:51 INFO hadoop.MRInputHelpers: NumSplits: 33, SerializedSize: 12903
8607958 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: myudfs.jar
17/04/02 17:34:51 INFO tez.TezJobCompiler: Local resource: myudfs.jar
8607958 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: pig-0.16.0-amzn-0-core-h2.jar
17/04/02 17:34:51 INFO tez.TezJobCompiler: Local resource: pig-0.16.0-amzn-0-core-h2.jar
8607958 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: antlr-runtime-3.4.jar
17/04/02 17:34:51 INFO tez.TezJobCompiler: Local resource: antlr-runtime-3.4.jar
8607958 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: joda-time-2.8.1.jar
17/04/02 17:34:51 INFO tez.TezJobCompiler: Local resource: joda-time-2.8.1.jar
8607958 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Local resource: automaton-1.11-8.jar
17/04/02 17:34:51 INFO tez.TezJobCompiler: Local resource: automaton-1.11-8.jar
17/04/02 17:34:51 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
8607996 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-324: parallelism=33, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 17:34:51 INFO tez.TezDagBuilder: For vertex - scope-324: parallelism=33, memory=1536, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx1229m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
8607996 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_subject,ntriples,raw,subjects
17/04/02 17:34:51 INFO tez.TezDagBuilder: Processing aliases: count_by_subject,ntriples,raw,subjects
8607996 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: raw[16,6],ntriples[-1,-1],count_by_subject[19,19],subjects[18,11]
17/04/02 17:34:51 INFO tez.TezDagBuilder: Detailed locations: raw[16,6],ntriples[-1,-1],count_by_subject[19,19],subjects[18,11]
8607996 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: 
17/04/02 17:34:51 INFO tez.TezDagBuilder: Pig features in the vertex: 
8608020 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-325: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 17:34:51 INFO tez.TezDagBuilder: For vertex - scope-325: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
8608020 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_count,count_by_subject,group_by_count
17/04/02 17:34:51 INFO tez.TezDagBuilder: Processing aliases: count_by_count,count_by_subject,group_by_count
8608020 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_subject[19,19],count_by_count[21,17],group_by_count[20,17]
17/04/02 17:34:51 INFO tez.TezDagBuilder: Detailed locations: count_by_subject[19,19],count_by_count[21,17],group_by_count[20,17]
8608020 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY
17/04/02 17:34:51 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY
8608040 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - For vertex - scope-326: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
17/04/02 17:34:51 INFO tez.TezDagBuilder: For vertex - scope-326: parallelism=50, memory=3072, java opts=-Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN -Xmx2458m -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
8608040 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Processing aliases: count_by_count
17/04/02 17:34:51 INFO tez.TezDagBuilder: Processing aliases: count_by_count
8608040 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Detailed locations: count_by_count[21,17]
17/04/02 17:34:51 INFO tez.TezDagBuilder: Detailed locations: count_by_count[21,17]
8608040 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder  - Pig features in the vertex: GROUP_BY
17/04/02 17:34:51 INFO tez.TezDagBuilder: Pig features in the vertex: GROUP_BY
8608064 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler  - Total estimated parallelism is 133
17/04/02 17:34:51 INFO tez.TezJobCompiler: Total estimated parallelism is 133
8608126 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState  - Pig script settings are added to the job
17/04/02 17:34:51 INFO tez.TezScriptState: Pig script settings are added to the job
17/04/02 17:34:51 INFO client.TezClient: Tez Client Version: [ component=tez-api, version=0.8.4, revision=30eccced8ce8c483445f0aa3175ce725831ff06b, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=2017-02-17T18:19:55Z ]
17/04/02 17:34:51 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 17:34:51 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
17/04/02 17:34:51 INFO client.TezClient: Using org.apache.tez.dag.history.ats.acls.ATSHistoryACLPolicyManager to manage Timeline ACLs
17/04/02 17:34:51 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 17:34:51 INFO client.TezClient: Session mode. Starting session.
17/04/02 17:34:51 INFO client.TezClientUtils: Using tez.lib.uris value from configuration: hdfs:///apps/tez/tez.tar.gz
17/04/02 17:34:51 INFO client.TezClientUtils: Using tez.lib.uris.classpath value from configuration: null
17/04/02 17:34:51 INFO client.TezClient: Tez system stage directory hdfs://ip-172-31-43-94.us-west-2.compute.internal:8020/tmp/temp458034843/.tez/application_1491115920200_0005 doesn't exist and is created
17/04/02 17:34:51 INFO acls.ATSHistoryACLPolicyManager: Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1491115920200_0005
17/04/02 17:34:51 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
17/04/02 17:34:51 INFO impl.YarnClientImpl: Submitted application application_1491115920200_0005
17/04/02 17:34:51 INFO client.TezClient: The url to track the Tez Session: http://ip-172-31-43-94.us-west-2.compute.internal:20888/proxy/application_1491115920200_0005/
8614563 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitting DAG PigLatin:DefaultJobName-0_scope-9
17/04/02 17:34:58 INFO tez.TezJob: Submitting DAG PigLatin:DefaultJobName-0_scope-9
17/04/02 17:34:58 INFO client.TezClient: Submitting dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0005, dagName=PigLatin:DefaultJobName-0_scope-9, callerContext={ context=PIG, callerType=PIG_SCRIPT_ID, callerId=PIG-default-ce74cf2a-ca84-4255-97af-b94147e40ad8 }
17/04/02 17:34:59 INFO client.TezClient: Submitted dag to TezSession, sessionName=PigLatin:DefaultJobName, applicationId=application_1491115920200_0005, dagName=PigLatin:DefaultJobName-0_scope-9
17/04/02 17:34:59 INFO impl.TimelineClientImpl: Timeline service address: http://ip-172-31-43-94.us-west-2.compute.internal:8188/ws/v1/timeline/
17/04/02 17:34:59 INFO client.RMProxy: Connecting to ResourceManager at ip-172-31-43-94.us-west-2.compute.internal/172.31.43.94:8032
8616189 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - Submitted DAG PigLatin:DefaultJobName-0_scope-9. Application id: application_1491115920200_0005
17/04/02 17:34:59 INFO tez.TezJob: Submitted DAG PigLatin:DefaultJobName-0_scope-9. Application id: application_1491115920200_0005
8617092 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher  - HadoopJobId: job_1491115920200_0005
17/04/02 17:35:00 INFO tez.TezLauncher: HadoopJobId: job_1491115920200_0005
8617192 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 17:35:00 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
8637191 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 0 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 17:35:20 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 0 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
8657370 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 2 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
17/04/02 17:35:40 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 2 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
8677370 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 5 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 1 KilledTaskAttempts: 2, diagnostics=, counters=null
17/04/02 17:36:00 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 5 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 1 KilledTaskAttempts: 2, diagnostics=, counters=null
8697370 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 7 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 3, diagnostics=, counters=null
17/04/02 17:36:20 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 7 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 3, diagnostics=, counters=null
8717370 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 8 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 4, diagnostics=, counters=null
17/04/02 17:36:40 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 8 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 3 KilledTaskAttempts: 4, diagnostics=, counters=null
8737370 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 10 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 4 KilledTaskAttempts: 6, diagnostics=, counters=null
17/04/02 17:37:00 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 10 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 4 KilledTaskAttempts: 6, diagnostics=, counters=null
8758029 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 12 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 4 KilledTaskAttempts: 7, diagnostics=, counters=null
17/04/02 17:37:21 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 12 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 4 KilledTaskAttempts: 7, diagnostics=, counters=null
8778181 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 15 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 5 KilledTaskAttempts: 8, diagnostics=, counters=null
17/04/02 17:37:41 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 15 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 5 KilledTaskAttempts: 8, diagnostics=, counters=null
8798181 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 18 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 10, diagnostics=, counters=null
17/04/02 17:38:01 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 18 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 10, diagnostics=, counters=null
8818182 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 21 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 11, diagnostics=, counters=null
17/04/02 17:38:21 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 21 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 6 KilledTaskAttempts: 11, diagnostics=, counters=null
8838182 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 25 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 7 KilledTaskAttempts: 12, diagnostics=, counters=null
17/04/02 17:38:41 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 25 Running: 2 Failed: 0 Killed: 0 FailedTaskAttempts: 7 KilledTaskAttempts: 12, diagnostics=, counters=null
9024808 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 26 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 8 KilledTaskAttempts: 13, diagnostics=, counters=null
17/04/02 17:41:48 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 26 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 8 KilledTaskAttempts: 13, diagnostics=, counters=null
9044808 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 28 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 9 KilledTaskAttempts: 14, diagnostics=, counters=null
17/04/02 17:42:08 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 28 Running: 3 Failed: 0 Killed: 0 FailedTaskAttempts: 9 KilledTaskAttempts: 14, diagnostics=, counters=null
9064808 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 31 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 9 KilledTaskAttempts: 15, diagnostics=, counters=null
17/04/02 17:42:28 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 31 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 9 KilledTaskAttempts: 15, diagnostics=, counters=null
9084808 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 44 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 10 KilledTaskAttempts: 16, diagnostics=, counters=null
17/04/02 17:42:48 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 44 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 10 KilledTaskAttempts: 16, diagnostics=, counters=null
9104808 [Timer-4] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 81 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 10 KilledTaskAttempts: 17, diagnostics=, counters=null
17/04/02 17:43:08 INFO tez.TezJob: DAG Status: status=RUNNING, progress=TotalTasks: 133 Succeeded: 81 Running: 1 Failed: 0 Killed: 0 FailedTaskAttempts: 10 KilledTaskAttempts: 17, diagnostics=, counters=null
9118042 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=SUCCEEDED, progress=TotalTasks: 133 Succeeded: 133 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 10 KilledTaskAttempts: 18, diagnostics=, counters=Counters: 65
	org.apache.tez.common.counters.DAGCounter
		NUM_FAILED_TASKS=10
		NUM_KILLED_TASKS=18
		NUM_SUCCEEDED_TASKS=133
		TOTAL_LAUNCHED_TASKS=144
		RACK_LOCAL_TASKS=33
		AM_CPU_MILLISECONDS=17160
		AM_GC_TIME_MILLIS=55
	File System Counters
		FILE_BYTES_READ=112177176
		FILE_BYTES_WRITTEN=27347764
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=1980
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=2211515152
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=20
		REDUCE_INPUT_GROUPS=789022
		REDUCE_INPUT_RECORDS=2113792
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=4227683
		NUM_SHUFFLED_INPUTS=3829
		NUM_SKIPPED_INPUTS=321
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=3829
		GC_TIME_MILLIS=47140
		CPU_MILLISECONDS=382340
		PHYSICAL_MEMORY_BYTES=185094635520
		VIRTUAL_MEMORY_BYTES=554815537152
		COMMITTED_HEAP_BYTES=185094635520
		INPUT_RECORDS_PROCESSED=10000000
		INPUT_SPLIT_LENGTH_BYTES=2211121475
		OUTPUT_RECORDS=10789022
		OUTPUT_BYTES=700691663
		OUTPUT_BYTES_WITH_OVERHEAD=154935658
		OUTPUT_BYTES_PHYSICAL=27245856
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=27241080
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=83
		SHUFFLE_BYTES=27239436
		SHUFFLE_BYTES_DECOMPRESSED=154933732
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=27239436
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=2810
		MERGE_PHASE_TIME=4054
		FIRST_EVENT_RECEIVED=865
		LAST_EVENT_RECEIVED=975
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=2113792
		COMBINE_OUTPUT_RECORDS=10788703
17/04/02 17:43:21 INFO tez.TezJob: DAG Status: status=SUCCEEDED, progress=TotalTasks: 133 Succeeded: 133 Running: 0 Failed: 0 Killed: 0 FailedTaskAttempts: 10 KilledTaskAttempts: 18, diagnostics=, counters=Counters: 65
	org.apache.tez.common.counters.DAGCounter
		NUM_FAILED_TASKS=10
		NUM_KILLED_TASKS=18
		NUM_SUCCEEDED_TASKS=133
		TOTAL_LAUNCHED_TASKS=144
		RACK_LOCAL_TASKS=33
		AM_CPU_MILLISECONDS=17160
		AM_GC_TIME_MILLIS=55
	File System Counters
		FILE_BYTES_READ=112177176
		FILE_BYTES_WRITTEN=27347764
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=0
		HDFS_BYTES_WRITTEN=1980
		HDFS_READ_OPS=150
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=100
		S3N_BYTES_READ=2211515152
		S3N_BYTES_WRITTEN=0
		S3N_READ_OPS=0
		S3N_LARGE_READ_OPS=0
		S3N_WRITE_OPS=0
	org.apache.tez.common.counters.TaskCounter
		NUM_SPECULATIONS=20
		REDUCE_INPUT_GROUPS=789022
		REDUCE_INPUT_RECORDS=2113792
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=4227683
		NUM_SHUFFLED_INPUTS=3829
		NUM_SKIPPED_INPUTS=321
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=3829
		GC_TIME_MILLIS=47140
		CPU_MILLISECONDS=382340
		PHYSICAL_MEMORY_BYTES=185094635520
		VIRTUAL_MEMORY_BYTES=554815537152
		COMMITTED_HEAP_BYTES=185094635520
		INPUT_RECORDS_PROCESSED=10000000
		INPUT_SPLIT_LENGTH_BYTES=2211121475
		OUTPUT_RECORDS=10789022
		OUTPUT_BYTES=700691663
		OUTPUT_BYTES_WITH_OVERHEAD=154935658
		OUTPUT_BYTES_PHYSICAL=27245856
		ADDITIONAL_SPILLS_BYTES_WRITTEN=0
		ADDITIONAL_SPILLS_BYTES_READ=27241080
		ADDITIONAL_SPILL_COUNT=0
		SHUFFLE_CHUNK_COUNT=83
		SHUFFLE_BYTES=27239436
		SHUFFLE_BYTES_DECOMPRESSED=154933732
		SHUFFLE_BYTES_TO_MEM=0
		SHUFFLE_BYTES_TO_DISK=0
		SHUFFLE_BYTES_DISK_DIRECT=27239436
		NUM_MEM_TO_DISK_MERGES=0
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=2810
		MERGE_PHASE_TIME=4054
		FIRST_EVENT_RECEIVED=865
		LAST_EVENT_RECEIVED=975
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.hadoop.mapreduce.TaskCounter
		COMBINE_INPUT_RECORDS=2113792
		COMBINE_OUTPUT_RECORDS=10788703
17/04/02 17:43:21 INFO Configuration.deprecation: fs.default.name is deprecated. Instead, use fs.defaultFS
9118905 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats  - Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 17:34:51                                                                                 
          FinishedAt: 2017-04-02 17:43:22                                                                                 
            Features: GROUP_BY                                                                                            

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-9                                                                   
                           ApplicationId: job_1491115920200_0005                                                                              
                      TotalLaunchedTasks: 144                                                                                                 
                           FileBytesRead: 112177176                                                                                           
                        FileBytesWritten: 27347764                                                                                            
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 1980                                                                                                
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-324	->	Tez vertex scope-325,
Tez vertex scope-325	->	Tez vertex scope-326,
Tez vertex scope-326

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-324         33         33       10000000                    0       10000000          79728         27186739              0                0 count_by_subject,ntriples,raw,subjects		
scope-325         50         50              0              2110044         788703      107197203           159381              0                0 count_by_count,count_by_subject,group_by_count	GROUP_BY	
scope-326         50         50              0                 3748            319        4900245             1644              0             1980 count_by_count	GROUP_BY	/user/hadoop/example_2_b,

Input(s):
Successfully read 10000000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000"

Output(s):
Successfully stored 319 records (1980 bytes) in: "/user/hadoop/example_2_b"

17/04/02 17:43:22 INFO tez.TezPigScriptStats: Script Statistics:

       HadoopVersion: 2.7.3-amzn-1                                                                                        
          PigVersion: 0.16.0-amzn-0                                                                                       
          TezVersion: 0.8.4                                                                                               
              UserId: hadoop                                                                                              
            FileName:                                                                                                     
           StartedAt: 2017-04-02 17:34:51                                                                                 
          FinishedAt: 2017-04-02 17:43:22                                                                                 
            Features: GROUP_BY                                                                                            

Success!


DAG 0:
                                    Name: PigLatin:DefaultJobName-0_scope-9                                                                   
                           ApplicationId: job_1491115920200_0005                                                                              
                      TotalLaunchedTasks: 144                                                                                                 
                           FileBytesRead: 112177176                                                                                           
                        FileBytesWritten: 27347764                                                                                            
                           HdfsBytesRead: 0                                                                                                   
                        HdfsBytesWritten: 1980                                                                                                
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-324	->	Tez vertex scope-325,
Tez vertex scope-325	->	Tez vertex scope-326,
Tez vertex scope-326

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-324         33         33       10000000                    0       10000000          79728         27186739              0                0 count_by_subject,ntriples,raw,subjects		
scope-325         50         50              0              2110044         788703      107197203           159381              0                0 count_by_count,count_by_subject,group_by_count	GROUP_BY	
scope-326         50         50              0                 3748            319        4900245             1644              0             1980 count_by_count	GROUP_BY	/user/hadoop/example_2_b,

Input(s):
Successfully read 10000000 records from: "s3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000"

Output(s):
Successfully stored 319 records (1980 bytes) in: "/user/hadoop/example_2_b"
