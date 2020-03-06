//
//  inputVoice_vc.swift
//  e-SMBG
//
//  Created by Francis Jemuel Bergonia on 3/3/20.
//

import UIKit
import AVFoundation
import Speech

@available(iOS 10.0, *)
class inputVoice_vc: UIViewController {
    
    // Storyboard elements
    @IBOutlet weak var alertBoxView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var inputValue: UILabel!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var mainSubView: UIView!
    
    @IBOutlet weak var microphoneButton: UIButton!
    

    // variables and constants
    var inputValueText: String?
    var langCode: String?
    
    //text to speech
    let speechSynthesizer = AVSpeechSynthesizer()
    
    //speech to text
    private var speechRecognizer: SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    @IBAction func textToSpeech(_ sender: Any) {
        if let word = wordTextField.text{
            if !speechSynthesizer.isSpeaking {
                //get current dictionary
                let dictionary = fetchSelectedDictionary()
                //get current language
                let language = languagesWithCodes[(dictionary?.language)!]
                let speechUtterance = AVSpeechUtterance(string: word)
                speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
                speechUtterance.rate = 0.4
                //speechUtterance.pitchMultiplier = pitch
                //speechUtterance.volume = volume
                speechSynthesizer.speak(speechUtterance)
            } else {
                speechSynthesizer.continueSpeaking()
            }
        }
    }
    
    @IBAction func speechToText(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeDefault)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                self.wordTextField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.microphoneButton.isEnabled = true
            }
        })
    }
 


}
