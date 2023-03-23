chrome trace
asChromeTraceIn: recorder 
	|   timeOffset record |
	
	
	"https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/edit#heading=h.nso4gcezn7n1"
	
	"## Format 
name: The name of the event, as displayed in Trace Viewer
cat: The event categories. This is a comma separated list of categories for the event. The categories can be used to hide events in the Trace Viewer UI.
ph: The event type. This is a single character which changes depending on the type of event being output. The valid values are listed in the table below. We will discuss each phase type below.
ts: The tracing clock timestamp of the event. The timestamps are provided at microsecond granularity.
tts: Optional. The thread clock timestamp of the event. The timestamps are provided at microsecond granularity.
pid: The process ID for the process that output this event.
tid: The thread ID for the thread that output this event.
args: Any arguments provided for the event. Some of the event types have required argument fields, otherwise, you can put any information you wish in here. The arguments are displayed in Trace Viewer when you view an event in the analysis section.
Optional
cname: A fixed color name to associate with the event. If provided, cname must be one of the names listed in trace-viewer's base color scheme's reserved color names list"

"
B (begin), E (end)

X Complete Events

i Instant Events

I  Deprecated

C Counter Events

Async Events
b (nestable start), n (nestable instant), e (nestable end)

Deprecated
S (start), T (step into), p (step past), F (end)

Flow Events
s (start), t (step), f (end)

Sample Events
P Object Events
N (created), O (snapshot), D (destroyed)


M Metadata Events

Memory Dump Events
V (global), v (process)

Mark Events
R

Clock Sync Events
c

Context Events
(, )
"		
	
timeOffset := recorder topRecord beginTime. 

record := self.

^{
	#pid -> 1.
	#tid -> 1.
	#ts -> (record beginTime ifNotNilDo: [ :beginTime | (recorder highResToTime: (beginTime - timeOffset))]) .
	#dur -> (record endTime ifNotNilDo: [ :endTime | (recorder highResToTime: (endTime - record beginTime))]) .
	#ph -> 'X'.					
	#name -> (record method selector  asString).
	#args -> ({
		#className -> record receiverClass name asString.
		#argumentNames -> record extension  argumentNames.
	}  as: Dictionary).
 } as: Dictionary.
	