//
// Shinobi - Tensorflow Plugin
// Copyright (C) 2016-2025 Moe Alam, moeiscool
//
// # Donate
//
// If you like what I am doing here and want me to continue please consider donating :)
// PayPal : paypal@m03.ca
//


// ==============================================================
// IF THIS TEST FAILS REINSTALL THE FOLLOWING NPM MODULES
//  - tfjs-core@2.3.0
//  - tfjs-converter@2.3.0
// version 2.3.0 is selected for this example. Make it point to the version of tfjs-node(-gpu) in use.
// ==============================================================
// Not working still? You may need to run following inside this folder.
// npm rebuild @tensorflow/tfjs-node-gpu@1.7.3 build-addon-from-source --unsafe-perm
// ==============================================================

console.log('############################################')
console.log('@tensorflow/tfjs-node(-gpu) module test for Object Detection')

// Base Init >>
var fs = require('fs');
const fetch = require('node-fetch');
// Base Init />>
var tf
const tfjsBuild = process.argv[2]
try{
    switch(tfjsBuild){
        case'gpu':
            console.log('GPU Test for Tensorflow Module')
            tf = require('@tensorflow/tfjs-node-gpu')
        break;
        case'cpu':
            console.log('CPU Test for Tensorflow Module')
            tf = require('@tensorflow/tfjs-node')
        break;
        default:
            console.log('Nothing selected, using CPU Module for test.')
            console.log(`Hint : Run the script like one of the following to specify cpu or gpu.`)
            console.log(`node test.js cpu`)
            console.log(`node test.js gpu`)
            tf = require('@tensorflow/tfjs-node')
        break;
    }
}catch(err){
    console.log(`Selection Failed. Could not load desired module. ${tfjsBuild}`)
    console.log(err)
}
if(!tf){
    try{
        tf = require('@tensorflow/tfjs-node-gpu')
    }catch(err){
        try{
            tf = require('@tensorflow/tfjs-node')
        }catch(err){
            return console.log('tfjs-node could not be loaded')
        }
    }
}
console.log('############################################')

  const cocossd = require('@tensorflow-models/coco-ssd');
  // const mobilenet = require('@tensorflow-models/mobilenet');


  async function loadCocoSsdModal() {
      const modal = await cocossd.load({
          base: 'lite_mobilenet_v2', //lite_mobilenet_v2
          modelUrl: null,
      })
      return modal;
  }

  // async function loadMobileNetModal() {
  //     const modal = await mobilenet.load({
  //         version: 1,
  //         alpha: 0.25 | .50 | .75 | 1.0,
  //     })
  //     return modal;
  // }

  function getTensor3dObject(numOfChannels,imageArray) {

      const tensor3d = tf.node.decodeJpeg( imageArray, numOfChannels );

      return tensor3d;
  }
  // const mobileNetModel =  this.loadMobileNetModal();
  var loadCocoSsdModel = {
      detect: function(){
          return {data:[]}
      }
  }
  async function init() {
      loadCocoSsdModel =  await loadCocoSsdModal();
  }
  init()
  const runDetection = async (inputImage,type) => {

      const startTime = new Date();
      const tensor3D = getTensor3dObject(3,(inputImage));
      let predictions = await loadCocoSsdModel.detect(tensor3D);

      tensor3D.dispose();

      return {
          data: predictions,
          type: type,
          time: new Date() - startTime
      }
  }

const testImageUrl = `https://cdn.shinobi.video/images/test/car.jpg`
const testImageUrl2 = `https://cdn.shinobi.video/images/test/bear.jpg`
const testImageUrl3 = `https://cdn.shinobi.video/images/test/people.jpg`
const runTest = async (imageUrl) => {
    console.log(`Loading ${imageUrl}`)
    const response = await fetch(imageUrl);
    const frameBuffer = await response.buffer();
    console.log(`Detecting upon ${imageUrl}`)
    const resp = await runDetection(frameBuffer)
    const results = resp.data
    console.log(resp)
    if(results[0]){
        var mats = []
        console.log('Detected Objects!')
        results.forEach(function(v){
            console.log({
                x: v.bbox[0],
                y: v.bbox[1],
                width: v.bbox[2],
                height: v.bbox[3],
                tag: v.class,
                confidence: v.score,
            })
        })
    }else{
        console.log('No Matrices...')
    }
    console.log(`Done ${imageUrl}`)
}
const allTests = async () => {
    await runTest(testImageUrl)
    await runTest(testImageUrl2)
    await runTest(testImageUrl3)
}
allTests()
