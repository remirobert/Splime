<p align="center">
  <img src ="https://cloud.githubusercontent.com/assets/3276768/12470123/bfe1a198-c045-11e5-8960-7b5d59c4c8da.png"/>
</p>
</br>

**Splime**, is a tool, lets you to *split a video into frames*. It allows you to collect some informations about the video itself, in the same time. Splime use **AVFoundation** framework.

#Installation
**Splime** is avalaible on **cocoapods**.
Simply add this on your **Podfile** :

```ruby
use_frameworks!
pod 'Splime', '~> 1.0.1'
```

#Usage 🛠

**Splime**, return you a completion block : **(images: [UIImage]) -> ()**, to let's you get the splited frames. And also an *optional* progress block : **((progress: Float) -> ())?**, to follows the progress of the spliter.

```swift
videoSpliter = Splime(url: stringPath)
videoSpliter.split({ (images) -> () in
    //use the [UIImage], images frames            
  }, progressBlock: { (progress) -> () in
    print("current progress : [\(progress)]")
})
```

#Video informations 📊

**Splime** gathers some informations relative to the video. **Splime** can also be used for that usage.
You can collect, the **total number** of frames in the video, the **total duration** (in second), the **time per frame**, and so on. When you init a new **Splime** object with a valid video's URL, or set a new URL, **Splime** with fill a struct with all that informations. All this informations, are read-only for safety ⚠️, because they are used in the split method.

```Swift
videoSpliter = Splime(url: stringPath)
//Informations collected

videoSpliter.url = stringPath2
//new Informations collected

//get informations:
videoSpliter.assetInformations.timeScale
videoSpliter.assetInformations.timeValuePerFrame
videoSpliter.assetInformations.totalFrames
videoSpliter.assetInformations.totalSeconds
videoSpliter.assetInformations.frameRate
```

#Configuration ⚙

**Splime** gives you the ability to configure the way you want to separate frames.
You can specifie:
- A **time interval**, for example split from 4 sec to 15 sec, of the video.
- A number of maximal amount of frames you want (*I want 60 frames at the maximal, and no matter what !!*)
- The number of frames per interval. For example I want to take a frame every 10.

```swift
//For the time interval, CMTime is used, to let you use, a very high precision.
//You can use the same timeScale as the video, avalaible in the video information.
//Split the frames from the 4 secondes, to the 10 secondes.
videoSpliter.startInterval = CMTimeMake(4, videoSpliter.assetInformations.timeScale)
videoSpliter.endInterval = CMTimeMake(10, videoSpliter.assetInformations.timeScale)

//Keep only one frame, every 5.
videoSpliter.everyFrames = 5

//Keep only 35 maximum frames.
//Can be used to limit the memory usage, if the video can.
videoSpliter.totalFrames = 35
```

