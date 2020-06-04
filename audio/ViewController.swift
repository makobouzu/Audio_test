//
//  ViewController.swift
//  audio
//
//  Created by Makoto Amano on 2020/06/03.
//  Copyright © 2020 Makoto Amano. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    var recNow = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func record(){
        if !isRecording {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let dt = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm:ss", options: 0, locale: Locale(identifier: "jp_JP"))
            let date = formatter.string(from: dt)
            print(date)
            
            recNow = date
            audioRecorder = try! AVAudioRecorder(url: getURL(date), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            label.text = "録音中"
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false
            
        }else{
            
            audioRecorder.stop()
            isRecording = false
            
            label.text = "待機中"
            recordButton.setTitle("REC", for: .normal)
            playButton.isEnabled = true
            
        }
    }
    
    @IBAction func play(){
        if !isPlaying {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL(recNow))
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true
            
            label.text = "再生中"
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false
            
        }else{
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true
            
        }
    }
    
    func getURL(_ date: String) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        print(docsDirect)
        let url = docsDirect.appendingPathComponent(date + ".m4a")
        return url
    }
}

