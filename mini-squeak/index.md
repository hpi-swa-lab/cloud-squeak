<!-- markdown-config presentation=true -->

<style data-src="https://lively-kernel.org/lively4/lively4-jens/src/client/presentation.css"></style>
<style data-src="https://lively-kernel.org/lively4/lively4-jens/src/client/lively.css"></style>
<style data-src="https://lively-kernel.org/lively4/lively4-jens/templates/livelystyle.css"></style>
<style data-src="./style.css"></style>


<style>
  li.box {
    width: 250px;
    height: 150px;
    list-style-type: none;
    float: left;
    border: 1px solid lightgray;
    margin: 10px;
    overflow: hidden;
  }
  h1,h2,h3,h4  {
    clear: left;
  }

  li.leftright {
    list-style-type: none;
    float:left; 
    width:400px;
  }
</style>


<div class="title">
Mini Image for a Cloud Squeak
</div>


<div class="subtitle">
(Short Experience Report)
</div>

<div class="authors">
  <u>Jens Lincke</u>, Tom Beckmann, Robert Hirschfeld
</div>

<div class="credentials">
  2023<br>
  <br>
  Software Architecture Group <br>Hasso Plattner Institute<br> University of Potsdam, Germany
</div>

---

# Motivation / Background

- Cloud functions
  - Deploy in cloud
  - When required a server is booted
  - Software is executed for a short time (15min)
  - Then shut down....
- This is not ideal for Squeak....
  - Image is big and Cloud Functions are charged by mainly RAM ...
- Goal: **Can we make a smaller Squeak Image?**

---

# Challenge

- How far can we shrink a Squeak Image?
- Manually shrink vs automatic shrink?
- Usable image vs throwaway image 
  - Marcel's vs. our approach

---

# Our Approach

- Create a script that shrinks any dev image to a minified one for the cloud
- The resulting image needs only to be capable of running the application code

--- 
##  1. Get a way to interact with Squeak not through the UI

- Install Telnet (because shell IO is to blocking)
- Use automatic script to shrink image

--- 
##  2. Repeat

- Uninstall parts of Squeak and see if the parts we are interested still work
  - Start with big image and produce mini image by running script
  - Run various analysis and visualizations (in the minimized target image )
  - Identify potential next targets for removal
  - add them those to shrinking script
- Produce JSON data in Squeak 
- [External visualization (in Lively4)](http://localhost:9005/Dropbox/hpi/Squeak/Tracing/lively/treemap.md?file=../aws-report.json)


---

## Shrinking Script

```Smalltalk
REPLCleaner>>>cleanupImage
	"startup code in new, minimal image"

	FileStream startUp: true.
	WeakArray restartFinalizationProcess.
	
	TranscriptStream redirectToStdOut: true.
	ToolSet default: REPLIsolatedToolset.
	
	Transcript showln: 'Starting to clean image ...'.
	self printObjectSpaceSize.
	
	Smalltalk cleanUp: true.
	
	self deleteProcesses.
	self deleteProjects.
	
	self printObjectSpaceSize.
	
	self deleteMostPackages.
	self deleteLargeMethods.
	
	self deleteClassOrganizations.
	
	
	Smalltalk garbageCollect.
	self findPinned do: #unpin.
	Smalltalk garbageCollect.
	
	Transcript showln: 'Cleaned!'.
	
	self printObjectSpaceSize.
	self saveFinal.
	
	Transcript showln: 'Write Space Tally'.
	
	self writeSpaceTally.
	
	Transcript showln: 'Now launching telnet'.
	REPLStartUp new open
	"TODO: save a new minimal image and launch the function handler"
```

---

## Space Tally

Custom Version of Squeal Space Tally that allows to measure classes


```Smalltalk

customSpaceForInstance: anObject depth: anInteger seen: seenObjectsOrNil

	| ctxt class basicSize depth total |
	seenObjectsOrNil ifNotNil: [
		(seenObjectsOrNil ifAbsentAdd: anObject) ifFalse: [^ 0]].
	(sizes includesKey: anObject) ifTrue: [^0]. "don't count double"
	sizes at: anObject put: -1. "working on it"
			
	ctxt := thisContext.
	class := ctxt objectClass: anObject.
	basicSize := 0.
	total := class isVariable
		ifTrue: [class byteSizeOfInstanceOfSize: (basicSize := ctxt objectSize: anObject)]
		ifFalse: [class isImmediateClass ifTrue: [0] ifFalse: [class byteSizeOfInstance]].
	(depth := anInteger - 1) >= 0 ifTrue: [
		anObject isCompiledCode
			ifTrue: [
				anObject literalsDo: [:literal | |other|
					total := total + (self spaceTallyAndFollowReferenceFrom: anObject to: literal via: literal mode: #literal seen: seenObjectsOrNil depth: depth).
				]]				
			ifFalse: [
				(class instSpec between: 2 and: 4) ifTrue: [ "only indexable objects, no bytes etc."
					1 to: basicSize do: [:index | |other|
						other :=  (ctxt object: anObject basicAt: index).
						(self followReferenceFrom: anObject to: other) ifTrue: [
							total := total + (self spaceTallyAndFollowReferenceFrom: anObject to: other via: index mode: #basic seen: seenObjectsOrNil depth: depth).
							]]].
				1 to: class instSize do: [:index | |other|
					other := (ctxt object: anObject instVarAt: index).
					total := total + (self spaceTallyAndFollowReferenceFrom: anObject to: other via: index mode: #var seen: seenObjectsOrNil depth: depth).
				]]].
	
	sizes at: anObject put: total. 
	
	^ total

```

---

### Result

- Shrink image to around 10MB on disk ....

```
-rwxrwxrwx 1 jens jens  87655152 Nov  4 13:06  aws.image
-rwxrwxrwx 1 jens jens   3891990 Nov  4 13:06  Squeak6.1min_02.changes
-rwxrwxrwx 1 jens jens     10057 Nov  4 13:06  SqueakDebug.log
-rwxrwxrwx 1 jens jens  10428120 Nov  4 13:07  aws-final.image
-rwxrwxrwx 1 jens jens    916842 Nov  4 13:07  aws-report.json
-rwxrwxrwx 1 jens jens    677422 Nov  4 13:07  aws-report.txt
```

---


### aws-report.txt

```
40096 #root -> Collections-SortFunctions Category [MsrSpaceTallyClassCategory]
	1125 #classInCategory -> ChainedSortFunction [ChainedSortFunction class]
			930 #methodDict -> a MethodDictionary(#,->(ChainedSortFunction>>#, "a CompiledMethod(2153261)") #=->(ChainedSortFunctio [MethodDictionary]
	31292 #metaClassInCategory -> ChainedSortFunction class [Metaclass]
			31024 #superclass -> ComposedSortFunction class [Metaclass]
				30773 #superclass -> SortFunction class [Metaclass]
					30502 #superclass -> Object class [Metaclass]
						30211 #methodDict -> a MethodDictionary(#basicReadFrom:->(Object class>>#basicReadFrom: "a CompiledMethod(960577)") #cate [MethodDictionary]
							28624 #array -> {nil . (Object class>>#flushEvents "a CompiledMethod(4106173)") . (Object class>>#readCarefullyFrom: [Array]
								21186  at: 6 -> (Object class>>#initializeDependentsFields "a CompiledMethod(1089894)") [CompiledMethod]
									21008  at: #DependentsFields->a WeakIdentityKeyDictionary(a TranscriptStream->a DependentsArray(MultiByteFileStream: #stdout) ) -> #DependentsFields->a WeakIdentityKeyDictionary(a TranscriptStream->a DependentsArray(MultiByteFileSt [Association]
										20960 #value -> a WeakIdentityKeyDictionary(a TranscriptStream->a DependentsArray(MultiByteFileStream: #stdout) ) [WeakIdentityKeyDictionary]
											20928 #array -> {nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil . nil [Array]
												19328  at: 103 -> a TranscriptStream->a DependentsArray(MultiByteFileStream: #stdout) [WeakKeyAssociation]
													12616 #key -> a WeakArray(a TranscriptStream) [WeakArray]
														12600  at: 1 -> a TranscriptStream [TranscriptStream]

...
```

--- 

### aws-report.json 

```
{"label":"root","class":"ByteSymbol","size":9599133,"selector":null,"id":1803901,"children":[{"label":"Collections-SortFunctions
Category","class":"MsrSpaceTallyClassCategory","size":40096,"selector":"#root","id":115344,"children":
[{"label":"ChainedSortFunction","class":"ChainedSortFunction class","size":1125,"selector":"#classInCategory","id":4434,"children":[{"label":"a MethodDictionary(#,->(ChainedSortFunction>>#, \"a CompiledMethod(2153261)\") #=->
(ChainedSortFunctio","class":"MethodDictionary","size":930,"selector":"#methodDict","id":1827042,"children":[]}]},
{"label":"ChainedSortFunction class","class":"Metaclass","size":31292,"selector":"#metaClassInCategory","id":3528,"children":[{"label":"ComposedSortFunction class","class":"Metaclass","size":31024,"selector":"#superclass","id":4437,"children":[{"label":"SortFunction class","class":"Metaclass","size":30773,"selector":"#superclass","id":3527,"children":[
{"label":"Object class","class":"Metaclass","size":30502,"selector":"#superclass","id":2532,"children":[{"label":"a MethodDictionary(#basicReadFrom:->(Object class>>#basicReadFrom: \"a CompiledMethod(960577)\") #cate","class":"MethodDictionary","size":30211,"selector":"#methodDict","id":3419458,"children":[
{"label":"{nil . (Object class>>#flushEvents \"a CompiledMethod(4106173)\") . (Object class>>#readCarefullyFrom:","class":"Array","size":28624,"selector":"#array","id":4028352,"children":[
{"label":"(Object class>>#initializeDependentsFields \"a CompiledMethod(1089894)\")",
"class":"CompiledMethod","size":21186,"selector":" at: 6","id":1089894,"children":[{"label":"#DependentsFields->a WeakIdentityKeyDictionary(a TranscriptStream->a DependentsArray(MultiByteFileSt","class":"Association"
,"size":21008,"selector":
" at: #DependentsFields->a WeakIdentityKeyDictionary(a TranscriptStream->a DependentsArray(MultiByteFileStream: #stdout) )","id":4167077,"children":[{"label":"a WeakIdentityKeyDictionary(a TranscriptStream->a DependentsArray(MultiByteFileStream: #stdout) )".....
```


--- 

### Visualization 

- [External visualization (in Lively4)](http://localhost:9005/Dropbox/hpi/Squeak/Tracing/lively/treemap.md?file=../aws-report.json)
- Problem: **Image on hard disk is much bigger than it should be**

![](media/final-aws-vis.png)



--- 

## 4. Analyze mini image directly 

- Use image loader from SqueakJS
- Visualize all objects as pixels on a canvas  [(AWS Final Image Visualization)](../image-loader/image-vis.md) 
 - ![](media/aws-final-image-zoomed-out.png)
- Discuss Findings on Mailing List / Hand over to VM Devs


--- 

## Report to Mailing List


<div class="lively-content" style="width: 800px; height: max-content;">
<div><p>Mar 24, 2023 19:08:00 Eliot Miranda &lt;<a href="mailto:eliot.miranda@gmail.com" target="_blank" style="color: rgb(17, 85, 204);">eliot.miranda@gmail.com</a>&gt;:</p></div><p></p><div dir="ltr"><div dir="ltr" style="color: rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><div class="gmail_default" style="font-size: small;">Hi Jens &amp; Tom,<br></div><div class="gmail_default" style="font-size: small;"><br></div><div class="gmail_default" style="font-size: small;">&nbsp; &nbsp; ah, SpurImagePreener doesn't clone the mark stack so nothing needs to&nbsp;be done for them.&nbsp; Only the remembered set needs to be shrunk.&nbsp; But empty class pages could be discarded, and if you could figure out how to rehash every dictionary you could reorder class indices to compact the class table.</div></div><br style="color: rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><div class="gmail_quote" style="color: rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><div dir="ltr" class="gmail_attr">On Fri, Mar 24, 2023 at 11:03 AM Eliot Miranda &lt;<a href="mailto:eliot.miranda@gmail.com" target="_blank" style="color: rgb(17, 85, 204);">eliot.miranda@gmail.com</a>&gt; wrote:<br></div><blockquote class="gmail_quote" style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;"><div dir="ltr"><div dir="ltr"><div style="font-size: small;">Hi Tom,<br></div></div><br><div class="gmail_quote"><div dir="ltr" class="gmail_attr">On Fri, Mar 24, 2023 at 8:53 AM Tom Beckmann &lt;<a href="mailto:tomjonabc@gmail.com" target="_blank" style="color: rgb(17, 85, 204);">tomjonabc@gmail.com</a>&gt; wrote:<br></div><blockquote class="gmail_quote" style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">&nbsp;<div dir="ltr">Hi list,<br><br>we're on a bit of an adventure to try and find the minimum size of a<span>&nbsp;</span><span class="il">Squeak</span><span>&nbsp;</span>image that can still run a stdio REPL. After narrowing it down to around 6MB, we noticed that SpaceTally reported ~3MB of objects (as opposed to the 6MB that were saved on-disk).<br></div></blockquote><div><br></div><div style="font-size: small;">Cool; a fine effort. &nbsp;i hope this leads to a small image running on a minheadless<span>&nbsp;</span><span class="il">VM</span><span>&nbsp;</span>for command-line scripting.</div><div style="font-size: small;"><br></div><blockquote class="gmail_quote" style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;"><div dir="ltr"><br>After a further deep-dive (in which SqueakJS and later the<span>&nbsp;</span><span class="il">VM</span><span>&nbsp;</span>simulator were of immense help), we found that there were 60 objects of class index 19, which took up 3MB of<span>&nbsp;</span><span class="il">space</span><span>&nbsp;</span>in the .image file. After some digging, we eventually found out that class index 19 are from SpurMemoryManager&gt;&gt;<wbr>sixtyFourBitLongsClassIndexPun<wbr>. As we understand it the "pun" objects are internal clones of the built-in classes (such as WeakArray, Array, ...), to prevent them from being found by a user.<br></div></blockquote><div><br></div><div style="font-size: small;">Almost.&nbsp; Puns are used to separate heap objects Spur uses internally from "user" Smalltalk objects. These are:</div><div style="font-size: small;">the class table: a sparse table used to map the class indices in every Smalltalk object header into the relevant class object</div><div style="font-size: small;">the remembered set: the objects in old<span>&nbsp;</span><span class="il">space</span><span>&nbsp;</span>that reference new objects and are hence roots for scavenging</div><div style="font-size: small;">the mark stack: the stack used to mark all old<span>&nbsp;</span><span class="il">space</span><span>&nbsp;</span>objects that holds objects that are being scanned for unmarked objects to scan and mark</div><div style="font-size: small;">the ephemeron stack: the stack used to hold potentially triggerable ephemerons found during scan mark</div><div style="font-size: small;"><br></div><div>Some of these objects look like raw data, some of them look like arrays.&nbsp; But all of them should&nbsp;be invisible to Smalltalk.&nbsp; So setting their class index to a pun&nbsp;hides them during allObjects, and allInstances.&nbsp; You'll find that the first few class indices, 1, 2 &amp; 4, are those for the immediate classes (e.g. {SmallInteger. Character. SmallFloat64} collect: #identityHash. Then you'll find that the lowest class&nbsp;identityHash is 32, of LargeNegativeInteger, hence:</div><div>&nbsp; &nbsp; ((Smalltalk specialObjectsArray select: [:e| e isBehavior]) collect: [:b| {b identityHash. b}]) sort: [:aa :ab| aa first &lt; ab first]</div><div style="font-size: small;"><br></div><div style="font-size: small;">The class indices from 8 through 31 are used for puns.</div><div style="font-size: small;"><br></div><blockquote class="gmail_quote" style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;"><div dir="ltr">We even managed to locate one of the larger class-index=19 objects with the help of Tom (WoC): the hiddenRootsObj contains in its 4099's slot the RememberedSet, which in our image was just over 1MB in size.<br><br>Now, we're wondering whether we can get closer to our goal of getting to the smallest possible on-disk image size (don't ask why, at this point it's more of a challenge...). Does the RememberedSet need to be persisted or could we (easily?) nil it before saving to disk? Are there other low hanging fruits in terms of<span>&nbsp;</span><span class="il">VM</span>-internal objects that could be freed during snapshot generation?<br></div></blockquote><div><br></div><div style="font-size: small;">It must&nbsp;be persisted. But it doesn't need to be that big.&nbsp; There is a tool in the VMMaker for eliminating this wasted<span>&nbsp;</span><span class="il">space</span>: SpurImagePreener.&nbsp; I can't guarantee that it currently prunes the remembered set (I just checked; it doesn't; should&nbsp;I fix it or would you like to fix it? It might be empowering for me to leave it to you).</div><div style="font-size: small;"><br></div><div>So you do e.g.&nbsp;SpurImagePreener new preenImage: 'trunk', and it outputs a hopefully&nbsp;shrunk trunk-preen.image. See SpurImagePreener's class comment.&nbsp; If you look at&nbsp;SpurImagePreener&gt;&gt;#<wbr>cloneObjects you'll see how to reduce the size of the remembered table (currently it only handles the free lists).&nbsp; I'll fix the mark stack, as the format of pages on the mark stack is a bit tricky, but I'll leave it to you to fix the remembered set size.</div><div style="font-size: small;">&nbsp; &nbsp;&nbsp;</div><blockquote class="gmail_quote" style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;"><div dir="ltr"><br>Best,<br>Jens (jl) and Tom (tobe)<br><br>PS: A not-so-clean version of the minification process can be found here<span>&nbsp;</span><a href="https://github.com/hpi-swa-lab/cloud-squeak" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://github.com/hpi-swa-lab/cloud-squeak&amp;source=gmail&amp;ust=1699183133793000&amp;usg=AOvVaw2gSenjNdkAVRe3uizrat4O" style="color: rgb(17, 85, 204);">https://github.com/hpi-swa-<wbr>lab/cloud-<span class="il">squeak</span></a><br>We're in the process of cleaning it up and might send out a proper announcement once it's pretty.<br></div></blockquote><div><br></div><div style="font-size: small;">Super cool!</div></div><div><br></div><div dir="ltr"><div dir="ltr"><div><span style="font-size: small; border-collapse: separate;"><div>_,,,^..^,,,_<br></div><div>best,&nbsp;Eliot</div><font color="#888888"></font></span></div><font color="#888888"></font></div><font color="#888888"></font></div><font color="#888888"></font></div><font color="#888888"></font></blockquote><font color="#888888"></font></div><font color="#888888" style="font-family: Arial, Helvetica, sans-serif; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><br class="Apple-interchange-newline">
</font></div></div>

---

## Limitations 

- No dynamic or static dependency tracing....
- Dependencies (things that should not be removed) have to be manually added to the shrink script
  - e.g. all code that is necessary to analyze / produce the visualizations needed to be on the ignore list
  



---

# Conclusion / Insights

- Open Challenge: How to make a nice non-blocking shell version of squeak
  - [new squeak issue](https://github.com/squeak-smalltalk/squeak-object-memory/issues/98)
  - (To replace telnet client)
- Squeak Image can be reduced quite a lot
- Actually using the minified image ... another day perhaps 

---
<!-- #TODO pull this up into presentation? -->
<script>
var ctx = this;

// poor men's slide master #Hack #TODO How to pull this better into lively-presentation?
(async () => {
  await lively.sleep(500)
  var presentation = lively.query(this, "lively-presentation")
  if (presentation && presentation.slides) {
    presentation.slides().forEach(ea => {
      var img = document.createElement("img")
      img.classList.add("logo")
      img.src="https://lively-kernel.org/lively4/lively4-seminars/PX2018/media/hpi_logo.png" 
      img.setAttribute("width", "50px")
      ea.appendChild(img)
      var div = document.createElement("div")
      div.classList.add("page-number")
      ea.appendChild(div)
    });
  } 
  return ""
})()
</script>