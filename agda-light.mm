<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1502187785826" ID="ID_747786108" MODIFIED="1502187811333" TEXT="agda-light">
<node CREATED="1497251493514" ID="ID_1699179955" MODIFIED="1497251523758" POSITION="right" TEXT="goals">
<node CREATED="1497251524922" ID="ID_940845241" MODIFIED="1497251528670" TEXT="fast">
<node CREATED="1497253086209" ID="ID_100143379" MODIFIED="1497253089062" TEXT="incremental compiler"/>
</node>
<node CREATED="1497251529098" ID="ID_1434752954" MODIFIED="1497251535806" TEXT="able to handle lots and lots of data"/>
<node CREATED="1497251711773" ID="ID_1581447956" MODIFIED="1497251714113" TEXT="secure"/>
</node>
<node CREATED="1497253947327" ID="ID_1247376037" MODIFIED="1497253948507" POSITION="right" TEXT="impl">
<node CREATED="1497250345513" ID="ID_1064998493" MODIFIED="1497251565023" TEXT="data types">
<node CREATED="1497250369593" FOLDED="true" ID="ID_199947811" MODIFIED="1502187830882" TEXT="I think can be represented by variables in wrapping lambdas">
<hook NAME="accessories/plugins/ClonePlugin.properties">
<Parameters CLONE_ID="CLONE_427936853" CLONE_IDS="ID_603995098,ID_199947811," CLONE_ITSELF="true"/>
</hook>
<node CREATED="1497250424045" ID="ID_76782203" MODIFIED="1497250425078" TEXT="Ex">
<node CREATED="1497250390817" ID="ID_1175392181" MODIFIED="1497250422750" TEXT="(\Maybe : Star -&gt; ....)">
<node CREATED="1497251583915" ID="ID_1009516915" MODIFIED="1497251588263" TEXT="define Maybe as a type"/>
<node CREATED="1497253473336" ID="ID_287486251" MODIFIED="1497253612794">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Lam &quot;Maybe&quot;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Kind Star)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Var &quot;Maybe&quot;) -- placeholder....code goes here....
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1497250426114" ID="ID_885414190" MODIFIED="1497250478430" TEXT="(\Nothing : Maybe -&gt; ...)">
<node CREATED="1497251604556" ID="ID_775386167" MODIFIED="1497251614223" TEXT="define &quot;Nothing&quot; as an object with a type of Maybe"/>
<node CREATED="1497253658626" ID="ID_1243640268" MODIFIED="1497253777284">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Lam &quot;Nothing&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Var &quot;Maybe&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Var &quot;Nothing&quot;) -- placeholder ..code goes here..
    </p>
    <p>
      
    </p>
    <p>
      typeCheck' (Lam &quot;Maybe&quot; (Kind Star) (Lam &quot;Nothing&quot; (Var &quot;Maybe&quot;) (Var &quot;Nothing&quot;)))
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1497250478908" ID="ID_1652371434" MODIFIED="1497311937835">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      (\Just : (forall A : * . x -&gt; x : A -&gt; Maybe) -&gt; ...)
    </p>
  </body>
</html></richcontent>
<node CREATED="1497250543683" ID="ID_1596055690" MODIFIED="1497250566024" TEXT="Here the user would supply an x and get back a Maybe in the form of Just x"/>
<node CREATED="1497315203835" ID="ID_1472565183" MODIFIED="1497315211644">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      (Lam &quot;Maybe&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;(Kind Star)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;(Lam &quot;Just&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160; &#160;&#160;(Pi &quot;A&quot; (Kind Star) (Pi &quot;_&quot; (Var &quot;A&quot;) (Var &quot;Maybe&quot;)))
    </p>
    <p>
      &#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;)
    </p>
    <p>
      )
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1497312038105" ID="ID_428938217" MODIFIED="1497315383432" TEXT="The point here is we create lam&apos;s that take variables that define what we want to be available. If we want a &quot;Maybe&quot;, then we create Lams for the maybe, nothing and a function just. The typechecker will keep us honest"/>
</node>
<node CREATED="1497251568275" ID="ID_1638447292" MODIFIED="1497251569534" TEXT="records?"/>
</node>
<node CREATED="1497318594693" ID="ID_827684609" MODIFIED="1497318598817" TEXT="implied variables"/>
<node CREATED="1497318548381" ID="ID_1561633859" MODIFIED="1497318552481" TEXT="inductive proofs"/>
<node CREATED="1497251595163" ID="ID_950964455" MODIFIED="1497251598432" TEXT="universal hierarchy"/>
<node CREATED="1497251543426" ID="ID_212139287" MODIFIED="1497251546583" TEXT="pattern matching"/>
<node CREATED="1497251571627" ID="ID_416966546" MODIFIED="1497251575526" TEXT="unification"/>
</node>
<node CREATED="1497251720669" ID="ID_1823272500" MODIFIED="1497251721921" POSITION="right" TEXT="design">
<node CREATED="1497251722750" ID="ID_637860183" MODIFIED="1497251728433" TEXT="database for symbols"/>
<node CREATED="1497251728789" ID="ID_1835863502" MODIFIED="1497253096046" TEXT="&quot;Whiteboard&quot; pattern for incremental compilation"/>
<node CREATED="1497251741022" ID="ID_295233746" MODIFIED="1497251758681" TEXT="Advanced agda features not implemented"/>
</node>
<node CREATED="1501479025960" ID="ID_1008652062" MODIFIED="1502251186093" POSITION="right" TEXT="draft 2">
<node CREATED="1501479220555" ID="ID_995738318" MODIFIED="1502187841294" TEXT="structure">
<node CREATED="1501479035836" ID="ID_1525480758" MODIFIED="1501479057008" TEXT="files">
<node CREATED="1501479057914" ID="ID_337337052" MODIFIED="1501479066507" TEXT="have reverse refs to objects that depend on them"/>
</node>
<node CREATED="1501479102607" ID="ID_178741124" MODIFIED="1501479104277" TEXT="directory">
<node CREATED="1501479072173" ID="ID_129366113" MODIFIED="1501479079125" TEXT="everything is through a directory lookup system"/>
<node CREATED="1501479081332" ID="ID_1222205501" MODIFIED="1501479092101" TEXT="so references can point to nothing, and are always unique"/>
<node CREATED="1501479110680" ID="ID_1049952608" MODIFIED="1501479115311" TEXT="this handles modules"/>
</node>
<node CREATED="1501479116765" ID="ID_669339319" MODIFIED="1501479154528" TEXT="objects">
<node CREATED="1501479156397" ID="ID_958273225" MODIFIED="1501479161678" TEXT="file location"/>
<node CREATED="1501479162105" ID="ID_1831031294" MODIFIED="1501479175176" TEXT="syntax+refs">
<node CREATED="1501479176710" ID="ID_415054232" MODIFIED="1501479179181" TEXT="type"/>
<node CREATED="1501479179526" ID="ID_1341032199" MODIFIED="1501479180577" TEXT="value"/>
</node>
<node CREATED="1501479189593" ID="ID_1886410516" MODIFIED="1501479191705" TEXT="reverse refs"/>
</node>
<node CREATED="1501484181773" ID="ID_1628280331" MODIFIED="1501484197913" TEXT="we use monads to handle dirtiness">
<node CREATED="1501484200540" ID="ID_99477146" MODIFIED="1501484205744" TEXT="main loop as follows">
<node CREATED="1501484207221" ID="ID_188276644" MODIFIED="1501484457871">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      do
    </p>
    <p>
      &#160;&#160;file &lt;- updateFile filepath
    </p>
    <p>
      &#160;&#160;sym &lt;- getAllSyms&#160;&#160;&#160;&#160;--gets all syms and runs the rest for each of them
    </p>
    <p>
      &#160;&#160;symText &lt;- symToText file&#160;&#160;--probably a lens or index into file
    </p>
    <p>
      &#160;&#160;symType &lt;- symToType symText
    </p>
    <p>
      &#160;&#160;symVal &lt;- symToValue symType symVal
    </p>
    <p>
      &#160;&#160;typeCheckRes &lt;- typeCheckSym symType symVal
    </p>
    <p>
      &#160;&#160;totCheckRes &lt;- totalityCheck symType symVal
    </p>
    <p>
      &#160;&#160;indCheckRes &lt;- inductiveLoopCheck symType symVal
    </p>
    <p>
      &#160;&#160;setStatus sym symText symType typeCheckRes totCheckRes indCheckRes
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1501484466148" ID="ID_122119928" MODIFIED="1501484482383" TEXT="Monad will handle multiple results (ie multiple syms) by running for each sym"/>
<node CREATED="1501484482732" ID="ID_215884748" MODIFIED="1501484501992" TEXT="The next step is only run if the previous step changes its input"/>
<node CREATED="1501484555571" ID="ID_72926101" MODIFIED="1501484568184" TEXT="End result is that when a file changes, only the syms that need to be recompiled are"/>
<node CREATED="1501484568716" ID="ID_172339222" MODIFIED="1501484597024" TEXT="Also, if syms depend on other syms, they will be run only after those other syms are valid"/>
<node CREATED="1501484597316" ID="ID_1451900888" MODIFIED="1501484650807" TEXT="syms are split into types and values, so that if two sym values depend on each other types, they won&apos;t create a loop in the system">
<node CREATED="1501479222844" ID="ID_619043353" MODIFIED="1501484669081" TEXT="loops">
<hook NAME="accessories/plugins/ClonePlugin.properties">
<Parameters CLONE_ID="CLONE_318958066" CLONE_IDS="ID_1807146090,ID_619043353," CLONE_ITSELF="true"/>
</hook>
<node CREATED="1501479230606" ID="ID_1129616395" MODIFIED="1501479238637" TEXT="loops are handled by compiling types first"/>
<node CREATED="1501479239239" ID="ID_1735681237" MODIFIED="1501479374469" TEXT="ex">
<node CREATED="1501479375474" ID="ID_462023924" MODIFIED="1501479396913">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      even : N -&gt; Bool
    </p>
    <p>
      even 0 = True
    </p>
    <p>
      even (S n) = odd n
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1501479398412" ID="ID_96444747" MODIFIED="1501479416631">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      odd : N -&gt; Bool
    </p>
    <p>
      odd 0 = False
    </p>
    <p>
      odd (S n) = even
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1501479417603" ID="ID_857859812" MODIFIED="1501479435768" TEXT="The values of each depend on the type of each other, so if types are compiled first, there is no issue"/>
</node>
</node>
</node>
<node CREATED="1501493651071" FOLDED="true" ID="ID_823782472" MODIFIED="1502187858378" TEXT="impl">
<node CREATED="1501493662503" ID="ID_1764105180" MODIFIED="1501503086560" TEXT="I&apos;m trying to design a compiler that stores its intermediate data to a file/database, and only recomputes what is necessary when a file in the project changes.&#xa;&#xa;I&apos;m thinking that a monad would be a way to go about this in a generic way, such as the following&#xa;&#xa;   class Monad m =&gt; CompMonadT m x where&#xa;      storeObject :: HasId -&gt; CompMonadT m x --stores an object to the database&#xa;      loadObject :: Id -&gt; CompMonadT m &#xa;&#xa;It would work with objects that all implemented an Id class:&#xa;&#xa;   class HasId x where&#xa;      id :: x -&gt; Id&#xa;&#xa;To run it, you could do something like&#xa;&#xa;   data CompFile = CompFile {&#xa;       fileName :: FilePath,&#xa;       contents :: Text&#xa;   }&#xa;&#xa;   instance HasId CompFile where&#xa;     id = fileName&#xa;&#xa;   main :: IO&#xa;   do&#xa;      let fooFile = CompFile &quot;foo.txt&quot; &quot;&lt;foo contents&gt;&quot;&#xa;      compilerState &lt;- loadCompilerState &quot;~/.compilerCacheDir&quot;&#xa;      addObject fooFile compilerState processFile&#xa;&#xa;where &quot;processFile&quot; is monadic function to parse files in the system. &#xa;&#xa;Within the monad, each step would produce an list of results, which would be processed like a List monad (where each result gets separately computed). &#xa;These results can be saved to a database using a &quot;store&quot; command. &#xa;&#xa;&#xa;If the intermediate results exactly match the values from the database&#xa;&#xa;For example:&#xa;&#xa;do &#xa;   file &lt;- updateFile filepath &#xa;   sym &lt;- getAllSyms    --gets all syms and runs the rest for each of them &#xa;   symText &lt;- symToText file  --probably a lens or index into file &#xa;&#xa;   symType &lt;- symToType symText &#xa;&#xa;   symVal &lt;- symToValue symType symVal &#xa;&#xa;   typeCheckRes &lt;- typeCheckSym symType symVal &#xa;&#xa;   totCheckRes &lt;- totalityCheck symType symVal &#xa;&#xa;   indCheckRes &lt;- inductiveLoopCheck symType symVal &#xa;&#xa;   setStatus sym symText symType typeCheckRes totCheckRes indCheckRes&#xa;&#xa;   "/>
</node>
<node CREATED="1501581553998" ID="ID_819911894" MODIFIED="1502251191975" TEXT="impl 2">
<node CREATED="1501581561069" ID="ID_324697757" MODIFIED="1501581576994" TEXT="objects">
<node CREATED="1501581578037" ID="ID_860222663" MODIFIED="1501581581584" TEXT="saved to database"/>
<node CREATED="1501581582677" ID="ID_1219923550" MODIFIED="1501581590833" TEXT="may have an action associated with them"/>
</node>
<node CREATED="1501581595764" ID="ID_1301992221" MODIFIED="1501581598128" TEXT="object + action">
<node CREATED="1501581599021" ID="ID_848320917" MODIFIED="1501581608840" TEXT="represented as a data item">
<node CREATED="1501581859228" ID="ID_1377872473" MODIFIED="1501581871920" TEXT="data item == haskell&apos;s &quot;data ... = &quot;"/>
</node>
<node CREATED="1501581875973" ID="ID_1486614020" MODIFIED="1501581896888" TEXT="instance of some class which provides an id, is showable, readable, etc."/>
<node CREATED="1501581609204" ID="ID_1211768589" MODIFIED="1501581625257" TEXT="can be read in using haskell&apos;s &quot;read&quot;"/>
</node>
<node CREATED="1501581626110" ID="ID_619305853" MODIFIED="1501581632641" TEXT="anchors">
<node CREATED="1501581633061" ID="ID_714024403" MODIFIED="1501581658065" TEXT="Every object must have an action that stores it, except for anchor objects"/>
<node CREATED="1501581658509" ID="ID_1869487307" MODIFIED="1501581678552" TEXT="This is used to provide initial objects which are maintained outside the system">
<node CREATED="1501581679413" ID="ID_830549053" MODIFIED="1501581712736" TEXT="ex. for a partial compiler, path + filename might be an anchor"/>
</node>
<node CREATED="1501581713772" ID="ID_1026011" MODIFIED="1501581733248" TEXT="anchors are run using an &quot;anchor monad&quot; which stores objects + actions">
<node CREATED="1501581735660" ID="ID_1585370998" MODIFIED="1501581748592" TEXT="These objects exist until manually removed">
<node CREATED="1501581751932" ID="ID_1529293873" MODIFIED="1501581764065" TEXT="using &quot;deleteObject&quot; from the anchor monad?"/>
</node>
</node>
</node>
<node CREATED="1501581823228" ID="ID_345605835" MODIFIED="1501581823929" TEXT="db">
<node CREATED="1501581772100" ID="ID_288429623" MODIFIED="1501581815425" TEXT="all objects are saved to the database immediately, so even if a program is killed half way through processing, it won&apos;t corrupt anything and can resume where it left off"/>
</node>
<node CREATED="1501581765884" ID="ID_577107096" MODIFIED="1501581770800" TEXT="versions">
<node CREATED="1501581826852" ID="ID_830384348" MODIFIED="1501581985368" TEXT="The actions may be updated in future versions of the software"/>
<node CREATED="1501581839908" ID="ID_769766535" MODIFIED="1501582007321" TEXT="This is handled by marking dirty a class of all items, causing their actions to be rerun"/>
</node>
<node CREATED="1501755448722" FOLDED="true" ID="ID_1867222163" MODIFIED="1502187906479" TEXT="backend">
<node CREATED="1501755457057" ID="ID_71915085" MODIFIED="1501811922002" TEXT="use acid-state?">
<node CREATED="1501755463850" ID="ID_993676768" MODIFIED="1501755480349" TEXT="acid-state needs everything stored in memory, so it won&apos;t work for finished product"/>
<node CREATED="1501811922958" ID="ID_636209172" MODIFIED="1501811942502" TEXT="unless we store each object as a separate acid store and key it by its filename"/>
</node>
<node CREATED="1501811946130" ID="ID_552024499" MODIFIED="1501811948478" TEXT="vcache"/>
<node CREATED="1501811948787" ID="ID_672038904" MODIFIED="1501811949855" TEXT="tcache"/>
<node CREATED="1501811950339" ID="ID_256046825" MODIFIED="1501811951870" TEXT="mem-map">
<node CREATED="1501811952747" ID="ID_397859599" MODIFIED="1501811968582" TEXT="A straight up mem map would work, but we&apos;d be reinventing atomic actions">
<node CREATED="1501811972643" ID="ID_1995057129" MODIFIED="1501811994710" TEXT="This is because when we write an object, we need it to write out completely or not at all"/>
</node>
</node>
<node CREATED="1501918751600" ID="ID_1527666217" MODIFIED="1501918754249" TEXT="my own system">
<node CREATED="1501918755273" ID="ID_54294431" MODIFIED="1501918762469" TEXT="we have two dirty queues">
<node CREATED="1501918763538" ID="ID_1857389420" MODIFIED="1501918772653" TEXT="in memory, works as normal.. for calculation"/>
<node CREATED="1501918772904" ID="ID_1860575855" MODIFIED="1501918773766" TEXT="disk">
<node CREATED="1501918774983" ID="ID_1697812256" MODIFIED="1501918787285" TEXT="A separate thread goes through and writes out these"/>
</node>
</node>
</node>
</node>
<node CREATED="1501755385549" ID="ID_645886704" MODIFIED="1501755394255" TEXT="fifo queue for dirty nodes">
<node CREATED="1501755397034" ID="ID_1018491746" MODIFIED="1501755421622" TEXT="this should prevent too much of a node being constantly rerun when one variable out of many changes">
<node CREATED="1501755434650" ID="ID_514603161" MODIFIED="1501755446774" TEXT="because after processing it once, it gets placed at the end of the queue"/>
</node>
<node CREATED="1502154964476" ID="ID_1566576530" MODIFIED="1502154985336" TEXT="We don&apos;t want threads to synchronize updating the dirty queue with work they have to do">
<node CREATED="1502154986267" ID="ID_1290887093" MODIFIED="1502155007559" TEXT="This would revert the system to single threadedness, since everyone would block on the dirty queue"/>
</node>
<node CREATED="1502155254147" ID="ID_1705097471" MODIFIED="1502173205731" TEXT="The plan is to do work and not remove dirty status until we sync to disk">
<node CREATED="1502173205716" ID="ID_271231987" MODIFIED="1502173206951" TEXT="process">
<node CREATED="1502173175308" ID="ID_1286698524" MODIFIED="1502173193616" TEXT="first the thread takes the work item from the queue and releases its lock"/>
<node CREATED="1502173194027" ID="ID_753685204" MODIFIED="1502173196791" TEXT="then it processes it"/>
</node>
<node CREATED="1502173207276" ID="ID_560395371" MODIFIED="1502173247304" TEXT="this may seem bad, since we are effectively removing dirty status before we process it, but since we do not sync to disk until the threads have completed all processing, it doesn&apos;t cause a problem"/>
<node CREATED="1502173247668" ID="ID_316801922" MODIFIED="1502173328880" TEXT="The rationale for this is that otherwise we&apos;ll need two queues. The original one and a second one for threads to pull work from, which is more complex"/>
</node>
<node CREATED="1502154914068" FOLDED="true" ID="ID_434955914" MODIFIED="1502613790299" TEXT="specifically works as follows">
<node CREATED="1502187917919" ID="ID_182887814" MODIFIED="1502187922045" TEXT="draft 1">
<node CREATED="1502154921916" ID="ID_1876310931" MODIFIED="1502155020776" TEXT="Scheduler Thread waits for items to be added to dirty queue"/>
<node CREATED="1502154936227" ID="ID_1430746453" MODIFIED="1502154955999" TEXT="When items are added, notifies a bunch of worker threads to process items"/>
<node CREATED="1502155024468" ID="ID_135916401" MODIFIED="1502173464080" TEXT="Wakes when Q is refilled OR threads finish their work"/>
<node CREATED="1502155048987" ID="ID_1628665930" MODIFIED="1502155062391" TEXT="There are two time categories">
<node CREATED="1502155063162" ID="ID_608759715" MODIFIED="1502155064479" TEXT="working"/>
<node CREATED="1502155064947" ID="ID_1872551129" MODIFIED="1502155068671" TEXT="waiting to sync"/>
</node>
<node CREATED="1502155101547" ID="ID_222998986" MODIFIED="1502155128407" TEXT="A timer kicks off and when it goes beyond 60 seconds or so (or whenever we want to start saving work), we stay in working time">
<node CREATED="1502173375227" ID="ID_1865017606" MODIFIED="1502173381336" TEXT="This is handled by a scheduler thread"/>
<node CREATED="1502155129963" ID="ID_990686076" MODIFIED="1502173396168" TEXT="After it goes off we go to waiting to sync time"/>
<node CREATED="1502173396595" ID="ID_1130031247" MODIFIED="1502173416032" TEXT="Another reason to make the switch might be a signal from the user to stop processing"/>
</node>
<node CREATED="1502155162522" ID="ID_1377806977" MODIFIED="1502155165991" TEXT="working time">
<node CREATED="1502155136851" ID="ID_199315582" MODIFIED="1502173542304" TEXT="In working time, whenever more items are added to the queue, scheduler thread is unpaused, and wakes the worker threads"/>
<node CREATED="1502173561548" ID="ID_1095631210" MODIFIED="1502174331203" TEXT="thread synchronization">
<node CREATED="1502175224220" ID="ID_1582407287" MODIFIED="1502175307529" TEXT="."/>
<node CREATED="1502174331189" ID="ID_1287169764" MODIFIED="1502174343704" TEXT="working time limit / user signal to stop">
<node CREATED="1502174260949" ID="ID_1702417225" MODIFIED="1502174285840" TEXT="there is an ioref indicating the time category (working time / waiting to sync time)">
<node CREATED="1502174287100" ID="ID_878690227" MODIFIED="1502174324968" TEXT="we can&apos;t use a mvar for a monitor and time category, because there isn&apos;t an easy way to wake up threads after they&apos;ve finished all the work"/>
</node>
<node CREATED="1502174346076" ID="ID_1189150781" MODIFIED="1502175156369" TEXT="client thread sets IORef indicating change of state, and wakes all worker threads">
<node CREATED="1502174392604" ID="ID_1749925507" MODIFIED="1502174392604" TEXT=""/>
</node>
</node>
<node CREATED="1502173571620" ID="ID_1749927769" MODIFIED="1502173769560" TEXT="worker threads communicate through a monitor">
<node CREATED="1502173770971" ID="ID_1382803629" MODIFIED="1502173790479" TEXT="Thread adding dirty items to queue notify all threads, which wake up if they were waiting for more work"/>
</node>
</node>
</node>
<node CREATED="1502155167051" ID="ID_1398482596" MODIFIED="1502155171767" TEXT="Waiting to Sync time">
<node CREATED="1502155172691" ID="ID_1284521653" MODIFIED="1502155190599" TEXT="Any additional items in the queue aren&apos;t touched"/>
<node CREATED="1502155191123" ID="ID_422493077" MODIFIED="1502155211199" TEXT="We wait until every worker thread finishes with its current job"/>
<node CREATED="1502155211739" ID="ID_126612358" MODIFIED="1502155240079" TEXT="We remove all dirty items from the queue that have been processed by the threads"/>
</node>
</node>
<node CREATED="1502187922443" ID="ID_379790110" MODIFIED="1502187923742" TEXT="draft 2">
<node CREATED="1502187926236" ID="ID_1051744328" MODIFIED="1502187933219" TEXT="one dirty fifo queue"/>
<node CREATED="1502190426163" ID="ID_236918593" MODIFIED="1502190433191" TEXT="do we really want to use STM?">
<node CREATED="1502190435454" ID="ID_1749824754" MODIFIED="1502190448181" TEXT="we may be able to just use IORefs">
<node CREATED="1502190449396" ID="ID_941113029" MODIFIED="1502190456078" TEXT="Presumably this would be faster"/>
<node CREATED="1502190456520" ID="ID_1830046499" MODIFIED="1502190675574" TEXT="We don&apos;t care if a thread reads a bad value, because we will mark it dirty after we fix it"/>
</node>
<node CREATED="1502190677349" ID="ID_1076266430" MODIFIED="1502190699611" TEXT="I like the idea, but we don&apos;t have a proper system for caching and storing these rows without STM"/>
<node CREATED="1502190700342" ID="ID_443451670" MODIFIED="1502190716661" TEXT="So PERF"/>
</node>
</node>
<node CREATED="1502251207330" ID="ID_1304650546" MODIFIED="1502251209493" TEXT="draft 3">
<node CREATED="1502251210896" ID="ID_961456878" MODIFIED="1502251238452" TEXT="each thread gives the scheduler thread its dirty items. The scheduler decides what to do with them"/>
<node CREATED="1502251238752" ID="ID_1938790409" MODIFIED="1502251284043" TEXT="When saving to the database, the scheduler will drain the queue from the worker threads, and place all new work into another list">
<node CREATED="1502251284952" ID="ID_1575956556" MODIFIED="1502251291643" TEXT="This list is then saved to the database"/>
</node>
<node CREATED="1502251456783" ID="ID_147928513" MODIFIED="1502251480715" TEXT="It seems like we could go slightly faster with monitors, but I&apos;m not sure.... and this should be good enough for a proof of concept"/>
</node>
</node>
</node>
<node CREATED="1501832379254" ID="ID_1343032697" MODIFIED="1501832381937" TEXT="errors">
<node CREATED="1501832391823" ID="ID_1606994342" MODIFIED="1501832921584" TEXT="for now, I think that we &quot;modifyObject&quot; on a list of errors"/>
<node CREATED="1501832921830" ID="ID_619523862" MODIFIED="1501832937954" TEXT="then we can look it up by id &quot;AllErrors&quot; or something"/>
</node>
<node CREATED="1501843900038" ID="ID_1438591902" MODIFIED="1501843904658" TEXT="multiple stores to the same object">
<node CREATED="1501843907166" ID="ID_474612122" MODIFIED="1501843917506" TEXT="These will be treated as errors for *both* stores">
<node CREATED="1501843918614" ID="ID_1295432090" MODIFIED="1501844144130" TEXT="also any load of a multiply set value will also error out">
<node CREATED="1501844147517" ID="ID_1031470904" MODIFIED="1501844160281" TEXT="somewhat like if it was not set at all"/>
</node>
<node CREATED="1501844161005" ID="ID_1879054244" MODIFIED="1501844193041" TEXT="this will preserve consistency"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1501479222844" ID="ID_1807146090" MODIFIED="1501484669081" TEXT="loops">
<hook NAME="accessories/plugins/ClonePlugin.properties">
<Parameters CLONE_ID="CLONE_318958066" CLONE_IDS="ID_1807146090,ID_619043353," CLONE_ITSELF="true"/>
</hook>
<node CREATED="1501479230606" ID="ID_1156162315" MODIFIED="1501479238637" TEXT="loops are handled by compiling types first"/>
<node CREATED="1501479239239" ID="ID_1107451987" MODIFIED="1501479374469" TEXT="ex">
<node CREATED="1501479375474" ID="ID_1665330905" MODIFIED="1501479396913">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      even : N -&gt; Bool
    </p>
    <p>
      even 0 = True
    </p>
    <p>
      even (S n) = odd n
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1501479398412" ID="ID_368037699" MODIFIED="1501479416631">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      odd : N -&gt; Bool
    </p>
    <p>
      odd 0 = False
    </p>
    <p>
      odd (S n) = even
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1501479417603" ID="ID_1442447689" MODIFIED="1501479435768" TEXT="The values of each depend on the type of each other, so if types are compiled first, there is no issue"/>
</node>
</node>
<node CREATED="1501479468841" ID="ID_942749343" MODIFIED="1501479471303" TEXT="blockchains">
<node CREATED="1501479472504" ID="ID_1876828300" MODIFIED="1501479485437" TEXT="blockchain changes can be inserted in place of files, above"/>
</node>
<node CREATED="1501480022954" ID="ID_1083713866" MODIFIED="1501480024084" TEXT="data">
<node CREATED="1501480024895" ID="ID_395653242" MODIFIED="1501480038696" TEXT="represented as unbound vars">
<node CREATED="1497250369593" FOLDED="true" ID="ID_603995098" MODIFIED="1502187826316" TEXT="I think can be represented by variables in wrapping lambdas">
<hook NAME="accessories/plugins/ClonePlugin.properties">
<Parameters CLONE_ID="CLONE_427936853" CLONE_IDS="ID_603995098,ID_199947811," CLONE_ITSELF="true"/>
</hook>
<node CREATED="1497250424045" ID="ID_400991769" MODIFIED="1497250425078" TEXT="Ex">
<node CREATED="1497250390817" ID="ID_511941027" MODIFIED="1497250422750" TEXT="(\Maybe : Star -&gt; ....)">
<node CREATED="1497251583915" ID="ID_839905413" MODIFIED="1497251588263" TEXT="define Maybe as a type"/>
<node CREATED="1497253473336" ID="ID_1900990056" MODIFIED="1497253612794">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Lam &quot;Maybe&quot;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Kind Star)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Var &quot;Maybe&quot;) -- placeholder....code goes here....
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1497250426114" ID="ID_1534274583" MODIFIED="1497250478430" TEXT="(\Nothing : Maybe -&gt; ...)">
<node CREATED="1497251604556" ID="ID_163668106" MODIFIED="1497251614223" TEXT="define &quot;Nothing&quot; as an object with a type of Maybe"/>
<node CREATED="1497253658626" ID="ID_1648853747" MODIFIED="1497253777284">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Lam &quot;Nothing&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Var &quot;Maybe&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;(Var &quot;Nothing&quot;) -- placeholder ..code goes here..
    </p>
    <p>
      
    </p>
    <p>
      typeCheck' (Lam &quot;Maybe&quot; (Kind Star) (Lam &quot;Nothing&quot; (Var &quot;Maybe&quot;) (Var &quot;Nothing&quot;)))
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1497250478908" ID="ID_141065050" MODIFIED="1497311937835">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      (\Just : (forall A : * . x -&gt; x : A -&gt; Maybe) -&gt; ...)
    </p>
  </body>
</html></richcontent>
<node CREATED="1497250543683" ID="ID_1989710097" MODIFIED="1497250566024" TEXT="Here the user would supply an x and get back a Maybe in the form of Just x"/>
<node CREATED="1497315203835" ID="ID_136065507" MODIFIED="1497315211644">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      (Lam &quot;Maybe&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;(Kind Star)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;(Lam &quot;Just&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160; &#160;&#160;(Pi &quot;A&quot; (Kind Star) (Pi &quot;_&quot; (Var &quot;A&quot;) (Var &quot;Maybe&quot;)))
    </p>
    <p>
      &#160;&#160;...
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;)
    </p>
    <p>
      )
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1497312038105" ID="ID_1095453211" MODIFIED="1497315383432" TEXT="The point here is we create lam&apos;s that take variables that define what we want to be available. If we want a &quot;Maybe&quot;, then we create Lams for the maybe, nothing and a function just. The typechecker will keep us honest"/>
</node>
</node>
</node>
<node CREATED="1501479607957" ID="ID_899075833" MODIFIED="1501481922834" TEXT="pattern matching?">
<node CREATED="1501480088623" ID="ID_135669629" MODIFIED="1501480101720" TEXT="Say you have &quot;foo (Just x)&quot;">
<node CREATED="1501480103061" ID="ID_758592853" MODIFIED="1501480117927" TEXT="You pattern match by first typechecking &quot;Just x&quot;"/>
<node CREATED="1501480122394" ID="ID_1954334627" MODIFIED="1501480126449" TEXT="&quot;x&quot; is unbound"/>
<node CREATED="1501480126748" ID="ID_1781943687" MODIFIED="1501480136279" TEXT="So, we let it&apos;s type be anything"/>
<node CREATED="1501480136796" ID="ID_1360696936" MODIFIED="1501480146960" TEXT="Then &quot;Just x&quot; becomes Maybe type"/>
<node CREATED="1501480147297" ID="ID_893277790" MODIFIED="1501480157726" TEXT="so as long as Foo :: Maybe -&gt; ..."/>
<node CREATED="1501480167507" ID="ID_447355953" MODIFIED="1501480171854" TEXT="it typechecks"/>
</node>
<node CREATED="1501480183263" ID="ID_981025530" MODIFIED="1501480190104" TEXT="what about totality checking?">
<node CREATED="1501481924657" ID="ID_931295508" MODIFIED="1501481935102" TEXT="This doesn&apos;t seem too hard"/>
<node CREATED="1501481935497" ID="ID_1944315163" MODIFIED="1501481948796" TEXT="You just make sure all definitions of a data type are covered"/>
</node>
</node>
<node CREATED="1501480217043" ID="ID_729559561" MODIFIED="1501480219789" TEXT="inductive proofs">
<node CREATED="1501480221188" ID="ID_1371971102" MODIFIED="1501480296771" TEXT="&quot;strictly smaller&quot; check in agda?">
<node CREATED="1501481966265" ID="ID_1497752957" MODIFIED="1501481969405" TEXT="Not sure about this"/>
</node>
</node>
<node CREATED="1501481979417" ID="ID_119761043" MODIFIED="1501481983916" TEXT="universal hierarchy">
<node CREATED="1501481987552" ID="ID_1766963115" MODIFIED="1501481994492" TEXT="not sure, but possible"/>
</node>
<node CREATED="1501482283440" ID="ID_1708804403" MODIFIED="1501482290245" TEXT="~/projects/agda-light"/>
</node>
</node>
</map>
