# Image Visualization



<script>
import ImageLoader from "https://lively-kernel.org/lively4/cloud-squeak/image-loader/image-loader.js"


var data;

if (!data) {
  // data = await fetch("http://localhost:9005/Dropbox/hpi/Squeak/Tracing/aws-final.image").then(r => r.arrayBuffer())
  
   data = await fetch("https://lively-kernel.org/lively4/cloud-squeak/image-loader/aws-final.image").then(r => r.arrayBuffer())

}


// (async () => {
//   data = null
//   data = await fetch("http://localhost:9005/Dropbox/hpi/Squeak/Tracing/Squeak6.1alpha-22475-64bit.image").then(r => r.arrayBuffer())
// })()


var imageLoader = new ImageLoader()
imageLoader.readFromBuffer(data)

var target = <div></div>
target.innerHTML = ""
target.appendChild(imageLoader.canvas)

// target.style.transformOrigin = "0 0"
// target.style.transform = "scale(1)"
imageLoader.canvas.style.width = (2048 * 1) +"px"
imageLoader.canvas.style["image-rendering"] = 'pixelated';


// Object.values(imageLoader.tally).sortBy(ea => ea.classID).slice(0,20)[1].data[1].length
// Object.values(imageLoader.tally).sortBy(ea => ea.classID).slice(0,20)[1].oops[1].bytes
// Object.values(imageLoader.tally).sortBy(ea => ea.classID).slice(0,20)[1].oops


target 

</script>







