//
//  VIdeoSpliter.swift
//  VideoSplitFrame
//
//  Created by Remi Robert on 19/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public class VIdeoSpliter: NSObject {
    
    public var totalFrames: Int = 0
    public var totalSeconds: Int = 0
    public var numberFrames: Int = 1
    public var totalFramesToCapture: Int = 0
    
    var startInterval: CMTime = {
        return CMTimeMakeWithSeconds(1, 990)
    }()
    var endInterval: CMTime?
    
    private var urlAsset: NSURL?
    public var url: String? {
        get {
            return self.urlAsset?.absoluteString
        }
        set {
            let fileManager = NSFileManager()
            if let urlString = newValue {
                if fileManager.fileExistsAtPath(urlString) {
                    self.urlAsset = NSURL(fileURLWithPath: urlString)
                }
            }
        }
    }
    
    private func times(track: AVAssetTrack, asset: AVAsset, beginSecond: CMTime?, endSecond: CMTime?) -> [NSValue] {
        var times = Array<NSValue>()
        
        let frameRate = track.nominalFrameRate
        let value = asset.duration.value
        let timeScale = Int64(asset.duration.timescale)
        let totalSeconds = Int64(value / timeScale)
        let totalFrames = totalSeconds * Int64(frameRate)
        
        let timeValuePerFrame = asset.duration.timescale / Int32(frameRate)
        
        let beginIntervalTime = (beginSecond != nil) ? beginSecond : CMTimeMakeWithSeconds(0, asset.duration.timescale)
        let endIntervalTime = (endSecond != nil) ? endSecond : CMTimeMakeWithSeconds(Double(totalSeconds), asset.duration.timescale)
        
        if self.totalFramesToCapture > 0 {
            if self.totalFramesToCapture > Int(totalFrames) {
                self.numberFrames = 1
            }
            else {
                self.numberFrames = Int(totalFrames) / self.totalFramesToCapture
            }
        }
        
        for (var indexFrame = 0; indexFrame < Int(totalFrames); indexFrame++) {
            
            if indexFrame % self.numberFrames == 0 {
                let timeValue = timeValuePerFrame * Int32(indexFrame)
                var frameTime = CMTime()
                frameTime.value = Int64(timeValue)
                frameTime.timescale = asset.duration.timescale
                
                frameTime.flags = asset.duration.flags
                frameTime.epoch = asset.duration.epoch
                
                if frameTime.value >= beginIntervalTime?.value && frameTime.value <= endIntervalTime?.value {
                    times.append(NSValue(CMTime: frameTime))
                }
                if frameTime.value >= endIntervalTime?.value {
                    return times;
                }
            }
        }
        return times;
    }
    
    private func getTrackVideo(asset: AVAsset) -> AVAssetTrack? {
        var track: AVAssetTrack?
        
        for currentTrack in asset.tracks {
            if currentTrack.mediaType == "vide" {
                print("found video track")
                track = currentTrack
            }
        }
        return track
    }
    
    public func videoFrames(completion : (images: [UIImage]) -> (), progressBlock: ((progress: Float) -> ())?) {
        guard let urlAsset = self.urlAsset else {
            print("error url not asset not found")
            return
        }
        
        let asset = AVAsset(URL: urlAsset)
        
        guard let track = self.getTrackVideo(asset) else {
            print("doesn't find video track")
            return
        }
        var currentIndexFrame = 0
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        var frames = Array<UIImage>()
        let times = self.times(track, asset: asset, beginSecond: nil, endSecond: nil)
        
        imageGenerator.generateCGImagesAsynchronouslyForTimes(times) { (requestedTime: CMTime, cgImage: CGImage?, currentTime: CMTime, result: AVAssetImageGeneratorResult, error: NSError?) -> Void in
            if error == nil && result == .Succeeded {
                if let cgImage = cgImage {
                    let currentImage = UIImage(CGImage: cgImage)
                    
                    if let progressBlock = progressBlock {
                        let currentProgress: Float = Float(Float(currentIndexFrame) / Float(times.count)) * 100
                        progressBlock(progress: Float(currentProgress))
                    }
                    
                    frames.append(currentImage)
                    currentIndexFrame += 1
                    
                    if frames.count == times.count {
                        completion(images: frames)
                        
                        if let progressBlock = progressBlock {
                            progressBlock(progress: 100)
                        }
                    }
                }
            }
            else {
                print("error generation : \(error)")
            }
        }
    }
    
    init(url: String) {
        super.init()
        self.url = url
    }    
}
