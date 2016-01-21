<p align="center">
  <img src ="https://cloud.githubusercontent.com/assets/3276768/12470123/bfe1a198-c045-11e5-8960-7b5d59c4c8da.png"/>
</p>
</br>

# Spliter
Split videos frames to => [UIImage]


#Usage

```swift
videoSpliter = VIdeoSpliter(url: stringPath)
videoSpliter.videoFrames({ (images) -> () in
                
  }, progressBlock: { (progress) -> () in
    print("current progress : [\(progress)]")
})
```
