<p align="center">
  <img src ="https://cloud.githubusercontent.com/assets/3276768/12470123/bfe1a198-c045-11e5-8960-7b5d59c4c8da.png"/>
</p>
</br>

# Spliter
Split videos frames to => [UIImage]


#Usage 🛠

Splime, return you a completion block : **(images: [UIImage]) -> ()**, to let's you get the splited frames. And also an *optional* progress block : **((progress: Float) -> ())?**, to follows the progress of the spliter.

```swift
videoSpliter = Splime(url: stringPath)
videoSpliter.split({ (images) -> () in
    //use the [UIImage], images frames            
  }, progressBlock: { (progress) -> () in
    print("current progress : [\(progress)]")
})
```

#Configuration ⚙
