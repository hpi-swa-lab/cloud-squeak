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
- External visualization (in Lively4)
http://localhost:9005/Dropbox/hpi/Squeak/Tracing/lively/treemap.md?file=../aws-report.json

![](media/final-aws-vis.png)

--- 

## 3. Mini image file size diverges from analysis and visualization 

- Problem: Image on hard disk is much bigger than it should be

--- 

## 4. Analyze mini image directly 

- Use image loader from SqueakJS
- Visualize all objects as pixels on a canvas  [(AWS Final Image Visualization)](../image-loader/image-vis.md) 
 - ![](media/aws-final-image-zoomed-out.png)
- Discuss Findings on Mailing List / Hand over to VM Devs


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