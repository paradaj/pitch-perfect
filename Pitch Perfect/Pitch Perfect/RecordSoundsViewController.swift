//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mac on 3/5/15.
//  Copyright (c) 2015 att. All rights reserved.
//
//  Reference information obtained from developer.apple.com
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var recordButtonState: String!
    var pauseImage: UIImage!
    var recordImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseImage = UIImage(named: "pause")
        recordImage = UIImage(named: "microphone")
        recordButtonState = "FIRSTTIME"
        recordingLabel.text = "Tap to Record"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true
        recordButton.setImage(recordImage, forState: .Normal)
        recordButtonState = "FIRSTTIME"
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        
        if (recordButtonState == "FIRSTTIME"){
            
            recordingLabel.text = "Recording in progress - Tap to pause"
            
            recordButtonState = "RECORDING"

            recordButton.setImage(pauseImage, forState: .Normal)
        
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
        
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        }
        
        else if (recordButtonState == "RECORDING"){
            audioRecorder.pause()
            recordingLabel.text = "Recording paused - Tap to continue"
            recordButton.setImage(recordImage, forState: .Normal)
            recordButtonState = "PAUSE"
        }
        
        else if (recordButtonState == "PAUSE"){
            audioRecorder.record()
            recordingLabel.text = "Recording in progress - Tap to pause"
            recordButton.setImage(pauseImage, forState: .Normal)
            recordButtonState = "RECORDING"
        }


    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag){
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
                        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }
        else{
            
            println("Recording was not successful !")
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

