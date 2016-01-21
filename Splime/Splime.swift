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

public struct AssetInformations {
    
    private var _frameRate: Float!
    var frameRate: Float! {
        get {
            return self._frameRate
        }
    }
    private var _value:CMTimeValue!
    var value: CMTimeValue! {
        get {
            return self._value
        }
    }
    private var _timeScale: Int32!
    var timeScale: Int32! {
        get {
            return self._timeScale
        }
    }
    private var _totalSeconds: Int32!
    var totalSeconds: Int32! {
        get {
            return self._totalSeconds
        }
    }
    private var _totalFrames: Int32!
    var totalFrames: Int32! {
        get {
            return self._totalFrames
        }
    }
    private var _timeValuePerFrame: Int32!
    var timeValuePerFrame: Int32! {
        get {
            return self._timeValuePerFrame
        }
    }
    
    init(asset: AVAsset, track: AVAssetTrack) {
        self._frameRate = track.nominalFrameRate
        self._value = asset.duration.value
        self._timeScale = Int32(asset.duration.timescale)
        self._totalSeconds = Int32(self.value) / self.timeScale
        self._totalFrames = self.totalSeconds * Int32(self.frameRate)
        self._timeValuePerFrame = asset.duration.timescale / Int32(self.frameRate)
    }
}

public class Splime: NSObject {
    
    private var asset: AVAsset?
    private var track: AVAssetTrack?
    
    public var everyFrames: Int = 1
    public var totalFrames: Int = 0
    
    private var _assetInformations: AssetInformations!
    public var assetInformations: AssetInformations! {
        get {
            return self._assetInformations
        }
    }
    
    public var startInterval: CMTime?
    public var endInterval: CMTime?
    
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
                    self.initAssetTrackVideo()
                }
            }
        }
    }
    
    private func getTrackVideo(asset: AVAsset) -> AVAssetTrack? {
        var track: AVAssetTrack?
        
        for currentTrack in asset.tracks {
            if currentTrack.mediaType == "vide" {
                track = currentTrack
            }
        }
        return track
    }
    
    private func initAssetTrackVideo() {
        if let urlAsset = self.urlAsset {
            self.asset = AVAsset(URL: urlAsset)
            if let asset = self.asset {
                self.track = self.getTrackVideo(asset)
            }
        }
    }
    
    private func times(track: AVAssetTrack, asset: AVAsset) -> [NSValue] {
        var times = Array<NSValue>()
        
        self._assetInformations = AssetInformations(asset: asset, track: track)
        
        let beginIntervalTime = (self.startInterval != nil) ? self.startInterval : CMTimeMakeWithSeconds(0, asset.duration.timescale)
        let endIntervalTime = (self.endInterval != nil) ? self.endInterval : CMTimeMakeWithSeconds(Double(self.assetInformations.totalSeconds), asset.duration.timescale)
        
        if self.totalFrames > 0 {
            if self.totalFrames > Int(self.assetInformations.totalFrames) {
                self.everyFrames = 1
            }
            else {
                self.everyFrames = Int(self.assetInformations.totalFrames) / self.totalFrames
            }
        }
        
        for (var indexFrame = 0; indexFrame < Int(self.assetInformations.totalFrames); indexFrame++) {
            
            if indexFrame % self.everyFrames == 0 {
                let timeValue = self.assetInformations.timeValuePerFrame * Int32(indexFrame)
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
    
    public func split(completion : (images: [UIImage]) -> (), progressBlock: ((progress: Float) -> ())?) {
        guard let asset = self.asset, track = self.track else {
            print("[Splime]: error asset / track video nil")
            return
        }
        
        var currentIndexFrame = 0
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        var frames = Array<UIImage>()
        let times = self.times(track, asset: asset)
        
        imageGenerator.generateCGImagesAsynchronouslyForTimes(times) { (_, cgImage: CGImage?, _, result: AVAssetImageGeneratorResult, error: NSError?) -> Void in
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
