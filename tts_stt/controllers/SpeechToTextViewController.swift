//
//  SpeechToTextViewController.swift
//  mood_capture
//
//  Created by MacBook on 04/11/24.
//

import UIKit
import AVFoundation
import Speech
class SpeechToTextViewController: UIViewController {

    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var imgMic: UIImageView!
    @IBOutlet weak var textMsg: UITextView!
    @IBOutlet weak var btnDelete: UIImageView!
    @IBOutlet weak var btnCopy: UIImageView!
    let speechRecognizer = SFSpeechRecognizer()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecordingStarted = false
    var audioFilename: URL?
    let audioEngine = AVAudioEngine()
    var audioRecorder: AVAudioRecorder?
    var lastProcessedSegmentIndex = 0 // Track the last segment index

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(loggout)
        )
        textViewModify()
        requestSpeechAuthorization()
        micGesture()
        copyBtnGesture()
        deleteBtnGesture()
    }
    
    @objc func loggout(){
        self.showLoader()
        FirebaseAuthManager().signOut(completion: {
            [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.hideLoader()
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.hideLoader()
                        self?.showToast(message: error.localizedDescription)
                    }
                }
        })
    }
    
    func micGesture(){
        imgMic.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(micTapped))
        imgMic.addGestureRecognizer(gesture)
    }
    
    func copyBtnGesture(){
        btnCopy.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector( copyTapped))
        btnCopy.addGestureRecognizer(gesture)
    }
    
    func deleteBtnGesture(){
        btnDelete.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        btnDelete.addGestureRecognizer(gesture)
    }
    
    func textViewModify(){
        textView.layer.cornerRadius = 10.0
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.3
        textView.layer.shadowOffset = CGSize(width: 0, height: 4)
        textView.layer.shadowRadius = 6.0
        textView.layer.masksToBounds = false
    }
    
    @objc func micTapped(){
        if(isRecordingStarted){
            stopListening()
        }else{
            startListening()
        }
    }

    @objc func copyTapped(){
        copyText()
    }
    
    @objc func deleteTapped(){
        print("delete Tapped  \(isRecordingStarted)")
        self.textMsg.text = ""
    }
    func startListening() {
        isRecordingStarted = true
        startMicPulseAnimation()
        imgMic.tintColor = UIColor.red
           // Ensure no other audio task is running
           if recognitionTask != nil {
               recognitionTask?.cancel()
               recognitionTask = nil
           }

           // Configure audio session
           let audioSession = AVAudioSession.sharedInstance()
           do {
               try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
               try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
           } catch {
               print("Audio session properties weren't set due to an error: \(error)")
               return
           }

           // Create and configure the recognition request
           recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
           guard let recognitionRequest = recognitionRequest else {
               print("Unable to create a recognition request")
               return
           }
           recognitionRequest.shouldReportPartialResults = true

           // Start recognition task
           recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
               if let result = result {
                   // Display the live transcribed text
//                   self.textMsg.text.append(result.bestTranscription.formattedString)
                  
//                   self.textMsg.text = result.bestTranscription.formattedString
                   
                 
                   print("Transcription: \(result.bestTranscription.formattedString)")
                   
                   if result.isFinal {
                       let newText = result.bestTranscription.formattedString
                       let previousText = self.textMsg.text ?? ""
                       self.textMsg.text = previousText + " " + newText

                       print("Final transcription: \(result.bestTranscription.formattedString)")
                   }
               }

               if error != nil || result?.isFinal == true {
                   self.stopListening() // Stop if there's an error or final result
               }
           }

           // Configure audio engine and start capturing audio
           let inputNode = audioEngine.inputNode
           let recordingFormat = inputNode.outputFormat(forBus: 0)
           inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
               self.recognitionRequest?.append(buffer)
           }

           audioEngine.prepare()
           do {
               try audioEngine.start()
               print("Audio engine started...")
           } catch {
               print("Audio engine couldn't start because of an error: \(error)")
           }
       }
    func stopListening() {
        isRecordingStarted = false
        stopMicPulseAnimation()
        imgMic.tintColor = UIColor.blue
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
            recognitionTask = nil
            print("Stopped listening and transcription.")
        }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func requestSpeechAuthorization() {
            SFSpeechRecognizer.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Speech recognition authorized.")
                case .denied, .restricted, .notDetermined:
                    print("Speech recognition not available or not authorized.")
                @unknown default:
                    fatalError("Unknown authorization status.")
                }
            }
        }
    
    func startMicPulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.3
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        imgMic.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    func stopMicPulseAnimation() {
        imgMic.layer.removeAnimation(forKey: "pulse")
    }
    
    @objc func copyText() {
        // Check if there's text to copy
        guard let textToCopy = self.textMsg.text, !textToCopy.isEmpty else {
            print("No text to copy")
            return
        }

        // Copy the text to the clipboard
        UIPasteboard.general.string = textToCopy
        
        // Optional: Show a confirmation
        let alert = UIAlertController(title: "Copied!", message: "The text has been copied to your clipboard.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}
