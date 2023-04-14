/* COPIED FROM SqueakJS */
const HeaderTypeMask = 3;
const HeaderTypeSizeAndClass = 0; //3-word header
const HeaderTypeClass = 1; //2-word header
const HeaderTypeFree = 2; //free block
const HeaderTypeShort = 3; //1-word header


export default class ImageLoader {
  constructor() {
    this.tally = {}
  }
  

  word64FromUint32(hi, lo) {
    // Max safe integer as Uint64: 001FFFFF_FFFFFFFF
    // Min safe integer as Uint64: FFE00000_00000001
    if (hi < 0x00200000) { // positive, <= 53 bits
      return hi * 0x100000000 + lo;
    } else if (hi > 0xFFE00000) { // negative, <= 53 bits
      return (hi >> 0) * 0x100000000 + lo;
    } else return [hi, lo]; // probably SmallFloat
  }

  initImmediateClasses(oopMap, rawBits, splObs) {
    var special = rawBits[splObs.oop];
    this.characterClass = oopMap[special[Squeak.splOb_ClassCharacter]];
    this.floatClass = oopMap[special[Squeak.splOb_ClassFloat]];
    this.largePosIntClass = oopMap[special[Squeak.splOb_ClassLargePositiveInteger]];
    this.largeNegIntClass = oopMap[special[Squeak.splOb_ClassLargeNegativeInteger]];
    // init named prototypes
    this.characterClass.classInstProto("Character");
    this.floatClass.classInstProto("BoxedFloat64");
    this.largePosIntClass.classInstProto("LargePositiveInteger");
    this.largeNegIntClass.classInstProto("LargeNegativeInteger");
    this.characterTable = {};
  }


  getCharacter(unicode) {
    var char = this.characterTable[unicode];
    if (!char) {
      char = new this.characterClass.instProto;
      char.initInstanceOfChar(this.characterClass, unicode);
      this.characterTable[unicode] = char;
    }
    return char;
  }

  instantiateFloat(bits) {
    var float = new this.floatClass.instProto;
    this.registerObjectSpur(float);
    this.hasNewInstances[this.floatClass.oop] = true;
    float.initInstanceOfFloat(this.floatClass, bits);
    return float;
  }
  
  colorForClass(classID) {
      if (!this.colorsForClassId)
        this.colorsForClassId ={}
      var color = this.colorsForClassId[classID]
      if (!color) {
        color = {
          r: Math.floor(Math.random()*255),
          g: Math.floor(Math.random()*255), 
          b: Math.floor(Math.random()*255)}
        this.colorsForClassId[classID] = color
      }
      return color
  }

  pixelIndex(x,y) {
    return (Math.floor(x) + Math.floor(y) * this.canvas.width);
  }
  
  setObjectForPixel(x,y, object) { 
    this.objectsForPixel[this.pixelIndex(x,y)] = object
  }

  getObjectForPixel(x,y, object) { 
    return this.objectsForPixel[this.pixelIndex(x,y)]
  }

  
  visualizPixel(x,y, color) { 
    var pixels =  this.canvasImagePixels  
    var pixelIndex =  this.pixelIndex(x,y)  * 4;
    pixels[pixelIndex] = color.r; // R
    pixels[pixelIndex + 1] = color.g; // G
    pixels[pixelIndex + 2] = color.b; // B
    pixels[pixelIndex + 3] = 255; // A
  }
  
  
  tallyObject(classID, objPos, bytes, data) { 
    this.counter++
    
    
    if (!this.tally[classID]) {
      this.tally[classID] = {classID: classID, count: 0, total: 0, oops: [], data: []}
    }
    
    if (classID === 19) {
      this.tally[classID].oops.push({
        objPos: objPos, bytes, toString: function() { return '['+this.oop+":"+this.bytes +']'}})
      
      this.tally[classID].data.push(data.slice(0, 32))
      // this.tally[classID].data.push(data)
    }
    this.tally[classID].count++
    this.tally[classID].total += bytes
    
    
    if (this.canvasCtx) {
      
      
      var color = this.colorForClass(classID)
      // var color = this.colorForClass(objPos)

      
      // if (this.counter > 1000) return
      
      
      // var objectSize = 64        
      // objPos = this.counter * objectSize
      // bytes = objectSize
      
      var pos = objPos
      while(pos < objPos + bytes) {
        
        // color objects with color of class
        
      var w = this.canvas.width * 8
        
        var x = pos  % w
        x -= (x % 8)
        x = x / 8
        
        var y = Math.floor(pos / w)
        
        y = y * 8
        
        
        // this.visualizPixel(x,y, color) 
        
        for(var i=0; i< 8; i++) {
          this.visualizPixel(x,y+i, color) 
          this.setObjectForPixel(x,y+i, {classID: classID, objPos, bytes, data}) 

        }
        
        
        

        
        // color pixels with data TODO
        // var i = Math.floor((pos - objPos) / 8)
        // pixels[pixelIndex] = data[i] % 255; 
        // pixels[pixelIndex + 1] = (data[i] / 255) % 255;
        // pixels[pixelIndex + 2] = (data[i] / 255 / 255) % 255;
        // pixels[pixelIndex + 3] = 255; 
        
        
        
        pos  += 8
      }
      
      
      // 
      // pos = objPos
      // pixelIndex =  pos * 4;
      // pixels[pixelIndex] = 255; // R
      // pixels[pixelIndex + 1] = 255; // G
      // pixels[pixelIndex + 2] = 255; // B
      // pixels[pixelIndex + 3] = 255; // A
      
      // this.canvasCtx.fillStyle = "black" 
      // this.canvasCtx.fillRect(objPos % this.canvas.width, Math.floor(objPos / this.canvas.width), 1, 1)
    
       
    }
  }
  
  visualizeImageBegin(size) {
    this.counter = 0 
    this.canvas = document.createElement('canvas');
    this.canvas.style.width = '2048px'
    this.canvas.style['image-rendering'] = "crisp-edges";
    this.canvas.width  = 2048;
    this.canvas.height = size / this.canvas.width;
    this.canvasCtx = this.canvas.getContext('2d')
    
    this.objectsForPixel = new Array()
    this.canvas.addEventListener("click", evt => {
      var pos = lively.getPosition(evt).subPt(lively.getGlobalPosition(this.canvas))
      
      var object = this.getObjectForPixel(Math.floor(pos.x), Math.floor(pos.y))
      
      lively.notify("click on " + JSON.stringify(object))
      
    })
    
    
    this.canvasImageData = this.canvasCtx.getImageData(0, 0, this.canvas.width, this.canvas.height);
    this.canvasImagePixels = this.canvasImageData.data;
  }

  visualizeImageEnd(size) {
    this.canvasCtx.putImageData(this.canvasImageData, 0, 0);
  }

  
  readFromBuffer(arraybuffer, thenDo, progressDo) {
    
    
    console.log('squeak: reading ' + this.name + ' (' + arraybuffer.byteLength + ' bytes)');
    var data = new DataView(arraybuffer),
      littleEndian = false,
      pos = 0;
    var readWord32 = function() {
      var int = data.getUint32(pos, littleEndian);
      pos += 4;
      return int;
    };
    var readWord64 = () => {
      // we assume littleEndian for now
      var lo = data.getUint32(pos, true),
        hi = data.getUint32(pos + 4, true);
      pos += 8;
      return this.word64FromUint32(hi, lo);
    };
    var readWord = readWord32;
    var wordSize = 4;
    var readBits = function(nWords, isPointers) {
      if (isPointers) { // do endian conversion
        var oops = [];
        while (oops.length < nWords)
          oops.push(readWord());
        return oops;
      } else { // words (no endian conversion yet)
        var bits = new Uint32Array(arraybuffer, pos, nWords * wordSize / 4);
        pos += nWords * wordSize;
        return bits;
      }
    };
    // read version and determine endianness
    var baseVersions = [6501, 6502, 6504, 68000, 68002, 68004],
      baseVersionMask = 0x119EE,
      version = 0,
      fileHeaderSize = 0;
    while (true) { // try all four endianness + header combos
      littleEndian = !littleEndian;
      pos = fileHeaderSize;
      version = readWord();
      if (baseVersions.indexOf(version & baseVersionMask) >= 0) break;
      if (!littleEndian) fileHeaderSize += 512;
      if (fileHeaderSize > 512) throw Error("bad image version"); // we tried all combos
    };
    this.version = version;
    var nativeFloats = (version & 1) !== 0;
    this.hasClosures = !([6501, 6502, 68000].indexOf(version) >= 0);
    this.isSpur = (version & 16) !== 0;
    // var multipleByteCodeSetsActive = (version & 256) !== 0; // not used
    var is64Bit = version >= 68000;
    if (is64Bit && !this.isSpur) throw Error("64 bit non-spur images not supported yet");
    if (is64Bit) {
      readWord = readWord64;
      wordSize = 8;
    }
    // parse image header
    var imageHeaderSize = readWord32(); // always 32 bits
    var objectMemorySize = readWord(); //first unused location in heap
    var oldBaseAddr = readWord(); //object memory base address of image
    var specialObjectsOopInt = readWord(); //oop of array of special oops
    this.savedHeaderWords = [];
    for (var i = 0; i < 7; i++) {
      this.savedHeaderWords.push(readWord32());
      if (is64Bit && i < 3) readWord32(); // skip half
    }
    var firstSegSize = readWord();
    var prevObj;
    var oopMap = {};
    var rawBits = {};
    var headerSize = fileHeaderSize + imageHeaderSize;
    pos = headerSize;

    this.visualizeImageBegin(firstSegSize)
   
    /*SPUR CASE*/
    {
      // Read all Spur object memory segments
      this.oldSpaceBytes = firstSegSize - 16;
      var segmentEnd = pos + firstSegSize,
        addressOffset = 0,
        classPages = null,
        skippedBytes = 0,
        oopAdjust = {};
      while (pos < segmentEnd) {
        while (pos < segmentEnd - 16) {
          // read objects in segment
          var objPos = pos,
            formatAndClass = readWord32(),
            sizeAndHash = readWord32(),
            size = sizeAndHash >>> 24;
          if (size === 255) { // this was the extended size header, read actual header
            size = formatAndClass;
            // In 64 bit images the size can actually be 56 bits. LOL. Nope.
            // if (is64Bit) size += (sizeAndHash & 0x00FFFFFF) * 0x100000000;
            formatAndClass = readWord32();
            sizeAndHash = readWord32();
          }
          var oop = addressOffset + pos - 8 - headerSize,
            format = (formatAndClass >>> 24) & 0x1F,
            classID = formatAndClass & 0x003FFFFF,
            hash = sizeAndHash & 0x003FFFFF;
          var bits = readBits(size, format < 10 && classID > 0);
          // align on 8 bytes, min size 16 bytes
          pos += is64Bit ?
            (size < 1 ? 1 - size : 0) * 8 :
            (size < 2 ? 2 - size : size & 1) * 4;
          // low class ids are internal to Spur
          
          
          this.tallyObject(classID, objPos, pos - objPos, bits)
        }
        if (pos !== segmentEnd - 16) throw Error("invalid segment");
        // last 16 bytes in segment is a bridge object
        var deltaWords = readWord32(),
          deltaWordsHi = readWord32(),
          segmentBytes = readWord32(),
          segmentBytesHi = readWord32();
        //  if segmentBytes is zero, the end of the image has been reached
        if (segmentBytes !== 0) {
          var deltaBytes = deltaWordsHi & 0xFF000000 ? (deltaWords & 0x00FFFFFF) * 4 : 0;
          segmentEnd += segmentBytes;
          addressOffset += deltaBytes;
          skippedBytes += 16 + deltaBytes;
          this.oldSpaceBytes += deltaBytes + segmentBytes;
        }
      }
      this.oldSpaceBytes -= skippedBytes;
      this.firstOldObject = oopMap[oldBaseAddr];
  
    }

    this.totalMemory = this.oldSpaceBytes + this.headRoom;

    this.visualizeImageEnd(firstSegSize)
    }
}


if (!Object.extend) {
  // Extend object by adding specified properties
  Object.extend = function(obj /* + more args */ ) {
    // skip arg 0, copy properties of other args to obj
    for (var i = 1; i < arguments.length; i++)
      if (typeof arguments[i] == 'object')
        for (var name in arguments[i])
          obj[name] = arguments[i][name];
  };
}


var Squeak = {};
Object.extend(Squeak,
  "version", {
    // system attributes
    vmVersion: "SqueakJS 1.0.5",
    vmDate: "2022-11-19", // Maybe replace at build time?
    vmBuild: "unknown", // or replace at runtime by last-modified?
    vmPath: "unknown", // Replace at runtime
    vmFile: "vm.js",
    vmMakerVersion: "[VMMakerJS-bf.17 VMMaker-bf.353]", // for Smalltalk vmVMMakerVersion
    platformName: "JS",
    platformSubtype: "unknown", // Replace at runtime
    osVersion: "unknown", // Replace at runtime
    windowSystem: "unknown", // Replace at runtime
  },
  "object header", {
    // object headers
    HeaderTypeMask: 3,
    HeaderTypeSizeAndClass: 0, //3-word header
    HeaderTypeClass: 1, //2-word header
    HeaderTypeFree: 2, //free block
    HeaderTypeShort: 3, //1-word header
  },
  "special objects", {
    // Indices into SpecialObjects array
    splOb_NilObject: 0,
    splOb_FalseObject: 1,
    splOb_TrueObject: 2,
    splOb_SchedulerAssociation: 3,
    splOb_ClassBitmap: 4,
    splOb_ClassInteger: 5,
    splOb_ClassString: 6,
    splOb_ClassArray: 7,
    splOb_SmalltalkDictionary: 8,
    splOb_ClassFloat: 9,
    splOb_ClassMethodContext: 10,
    splOb_ClassBlockContext: 11,
    splOb_ClassPoint: 12,
    splOb_ClassLargePositiveInteger: 13,
    splOb_TheDisplay: 14,
    splOb_ClassMessage: 15,
    splOb_ClassCompiledMethod: 16,
    splOb_TheLowSpaceSemaphore: 17,
    splOb_ClassSemaphore: 18,
    splOb_ClassCharacter: 19,
    splOb_SelectorDoesNotUnderstand: 20,
    splOb_SelectorCannotReturn: 21,
    splOb_TheInputSemaphore: 22,
    splOb_SpecialSelectors: 23,
    splOb_CharacterTable: 24,
    splOb_SelectorMustBeBoolean: 25,
    splOb_ClassByteArray: 26,
    splOb_ClassProcess: 27,
    splOb_CompactClasses: 28,
    splOb_TheTimerSemaphore: 29,
    splOb_TheInterruptSemaphore: 30,
    splOb_FloatProto: 31,
    splOb_SelectorCannotInterpret: 34,
    splOb_MethodContextProto: 35,
    splOb_ClassBlockClosure: 36,
    splOb_ClassFullBlockClosure: 37,
    splOb_ExternalObjectsArray: 38,
    splOb_ClassPseudoContext: 39,
    splOb_ClassTranslatedMethod: 40,
    splOb_TheFinalizationSemaphore: 41,
    splOb_ClassLargeNegativeInteger: 42,
    splOb_ClassExternalAddress: 43,
    splOb_ClassExternalStructure: 44,
    splOb_ClassExternalData: 45,
    splOb_ClassExternalFunction: 46,
    splOb_ClassExternalLibrary: 47,
    splOb_SelectorAboutToReturn: 48,
    splOb_SelectorRunWithIn: 49,
    splOb_SelectorAttemptToAssign: 50,
    splOb_PrimErrTableIndex: 51,
    splOb_ClassAlien: 52,
    splOb_InvokeCallbackSelector: 53,
    splOb_ClassUnsafeAlien: 54,
    splOb_ClassWeakFinalizer: 55,
  },
  "known classes", {
    // AdditionalMethodState layout:
    AdditionalMethodState_selector: 1,
    // Class layout:
    Class_superclass: 0,
    Class_mdict: 1,
    Class_format: 2,
    Class_instVars: null, // 3 or 4 depending on image, see instVarNames()
    Class_name: 6,
    // ClassBinding layout:
    ClassBinding_value: 1,
    // Context layout:
    Context_sender: 0,
    Context_instructionPointer: 1,
    Context_stackPointer: 2,
    Context_method: 3,
    Context_closure: 4,
    Context_receiver: 5,
    Context_tempFrameStart: 6,
    Context_smallFrameSize: 16,
    Context_largeFrameSize: 56,
    BlockContext_caller: 0,
    BlockContext_argumentCount: 3,
    BlockContext_initialIP: 4,
    BlockContext_home: 5,
    // Closure layout:
    Closure_outerContext: 0,
    Closure_startpc: 1,
    Closure_numArgs: 2,
    Closure_firstCopiedValue: 3,
    ClosureFull_method: 1,
    ClosureFull_receiver: 3,
    ClosureFull_firstCopiedValue: 4,
    // Stream layout:
    Stream_array: 0,
    Stream_position: 1,
    Stream_limit: 2,
    //ProcessorScheduler layout:
    ProcSched_processLists: 0,
    ProcSched_activeProcess: 1,
    //Link layout:
    Link_nextLink: 0,
    //LinkedList layout:
    LinkedList_firstLink: 0,
    LinkedList_lastLink: 1,
    //Semaphore layout:
    Semaphore_excessSignals: 2,
    //Mutex layout:
    Mutex_owner: 2,
    //Process layout:
    Proc_suspendedContext: 1,
    Proc_priority: 2,
    Proc_myList: 3,
    // Association layout:
    Assn_key: 0,
    Assn_value: 1,
    // MethodDict layout:
    MethodDict_array: 1,
    MethodDict_selectorStart: 2,
    // Message layout
    Message_selector: 0,
    Message_arguments: 1,
    Message_lookupClass: 2,
    // Point layout:
    Point_x: 0,
    Point_y: 1,
    // LargeInteger layout:
    LargeInteger_bytes: 0,
    LargeInteger_neg: 1,
    // WeakFinalizationList layout:
    WeakFinalizationList_first: 0,
    // WeakFinalizerItem layout:
    WeakFinalizerItem_list: 0,
    WeakFinalizerItem_next: 1,
  },
  "constants", {
    MinSmallInt: -0x40000000,
    MaxSmallInt: 0x3FFFFFFF,
    NonSmallInt: -0x50000000, // non-small and neg (so non pos32 too)
    MillisecondClockMask: 0x1FFFFFFF,
  },
  "error codes", {
    PrimNoErr: 0,
    PrimErrGenericFailure: 1,
    PrimErrBadReceiver: 2,
    PrimErrBadArgument: 3,
    PrimErrBadIndex: 4,
    PrimErrBadNumArgs: 5,
    PrimErrInappropriate: 6,
    PrimErrUnsupported: 7,
    PrimErrNoModification: 8,
    PrimErrNoMemory: 9,
    PrimErrNoCMemory: 10,
    PrimErrNotFound: 11,
    PrimErrBadMethod: 12,
    PrimErrNamedInternal: 13,
    PrimErrObjectMayMove: 14,
    PrimErrLimitExceeded: 15,
    PrimErrObjectIsPinned: 16,
    PrimErrWritePastObject: 17,
  },
  "modules", {
    // don't clobber registered modules
    externalModules: Squeak.externalModules || {},
    registerExternalModule: function(name, module) {
      this.externalModules[name] = module;
    },
  },
  "time", {
    Epoch: Date.UTC(1901, 0, 1) + (new Date()).getTimezoneOffset() * 60000, // local timezone
    EpochUTC: Date.UTC(1901, 0, 1),
    totalSeconds: function() {
      // seconds since 1901-01-01, local time
      return Math.floor((Date.now() - Squeak.Epoch) / 1000);
    },
  },
  "utils", {
    bytesAsString: function(bytes) {
      var chars = [];
      for (var i = 0; i < bytes.length;)
        chars.push(String.fromCharCode.apply(
          null, bytes.subarray(i, i += 16348)));
      return chars.join('');
    },
    word64FromUint32: function(hi, lo) {
      // Max safe integer as Uint64: 001FFFFF_FFFFFFFF
      // Min safe integer as Uint64: FFE00000_00000001
      if (hi < 0x00200000) { // positive, <= 53 bits
        return hi * 0x100000000 + lo;
      } else if (hi > 0xFFE00000) { // negative, <= 53 bits
        return (hi >> 0) * 0x100000000 + lo;
      } else return [hi, lo]; // probably SmallFloat
    },
  });


