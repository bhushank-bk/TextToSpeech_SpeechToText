//
//  TextToSpeechViewController.swift
//  mood_capture
//
//  Created by MacBook on 30/10/24.
//

import UIKit
import AVFoundation
import Vision


class TextToSpeechViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var speedSlider: UISlider!
    private let synthesizer = AVSpeechSynthesizer()
    private let audioEngine = AVAudioEngine()
    private var outputFile: AVAudioFile?
    private var audioFileURL: URL?
    private let textToSpeechViewModel = TextToSpeechViewModel()
    
    @IBOutlet weak var btnVoice: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var languageDropdown: UIButton!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnConvert: UIButton!
    
    
    //    let messge = "बिल्ली मौसी आई घर चूहे भागे धड़ाधड़। ek chupa almari me, दूसरा डिब्बे की सवारी में।"
    @IBOutlet weak var msgTextView: UITextView!
    
    var messge = "Billi"
    var voice = "Billi"
    var selectedLanguage: String = ""
    var rate: Float = 0.5
    var volume: Float = 1.0
    var pich: Float = 1.0
    var delay: Double = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
        chatViewModify()
        btnDeleteModify()
        filterViewModify()
        setLanguageDropdown()
        voiceBtnModify()
        btnConvertModify()
        
        speedSlider.value = 0.5
        speedSlider.minimumValue = 0.0
        speedSlider.maximumValue = 1.0
        
        volumeSlider.value = 1.0
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        
        pitchSlider.value = 1.0
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 2.0

        delaySlider.value = 0.5
        delaySlider.minimumValue = 0.0
        delaySlider.maximumValue = 1.0
    }

    @IBAction func btnDeleteClick(_ sender: UIButton) {
        self.msgTextView.text = ""
    }
    @IBAction func btnVoiceClick(_ sender: UIButton) {
        speakText(voice)
    }
    
    @IBAction func convertTxtToSpeech(_ sender: Any) {
        self.messge =  msgTextView.text
       
        speakText(messge)
    }
    
    @IBAction func speedSliderValueChanged(_ sender: UISlider) {
        rate = sender.value
    }
    
    
    @IBAction func volumeSliderValueChnged(_ sender: UISlider) {
        volume = sender.value
    }
    
    @IBAction func pichSliderValueChanged(_ sender: UISlider) {
        pich = sender.value
    }
    @IBAction func delyaSliderValueChanged(_ sender: UISlider) {
        delay = Double(sender.value)
    }
    func setLanguageDropdown(){
        
        
        languageDropdown.menu = createLanguageMenu()
        languageDropdown.setTitle("Select Language", for: .normal)
//        languageDropdown.showsMenuAsPrimaryAction = true
//
//        languageDropdown.changesSelectionAsPrimaryAction = true
        
        languageDropdown.semanticContentAttribute = .forceRightToLeft
        languageDropdown.configuration?.imagePadding = 5.0
        languageDropdown.configuration?.titlePadding = 5.0
        languageDropdown.layer.cornerRadius = 5.0
        languageDropdown.layer.shadowColor = UIColor.black.cgColor
        languageDropdown.layer.shadowOpacity = 0.3
        languageDropdown.layer.shadowOffset = CGSize(width: 0, height: 4)
        languageDropdown.layer.shadowRadius = 6.0
        languageDropdown.layer.masksToBounds = false
        languageDropdown.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Add padding as needed

    }
    func chatViewModify(){
        chatView.layer.cornerRadius = 10.0
        chatView.layer.shadowColor = UIColor.black.cgColor
        chatView.layer.shadowOpacity = 0.3
        chatView.layer.shadowOffset = CGSize(width: 0, height: 4)
        chatView.layer.shadowRadius = 6.0
        chatView.layer.masksToBounds = false
    }
    
    func btnConvertModify(){
        btnConvert.layer.cornerRadius = 10.0
        btnConvert.layer.shadowColor = UIColor.black.cgColor
        btnConvert.layer.shadowOpacity = 0.3
        btnConvert.layer.shadowOffset = CGSize(width: 0, height: 4)
        btnConvert.layer.shadowRadius = 6.0
        btnConvert.layer.masksToBounds = false
    }
    
    func voiceBtnModify(){
        btnVoice.layer.cornerRadius = 10.0
        btnVoice.layer.shadowColor = UIColor.black.cgColor
        btnVoice.layer.shadowOpacity = 0.3
        btnVoice.layer.shadowOffset = CGSize(width: 0, height: 4)
        btnVoice.layer.shadowRadius = 6.0
        btnVoice.layer.masksToBounds = false
    }
    
    func filterViewModify(){
        filterView.layer.cornerRadius = 10.0
        filterView.layer.shadowColor = UIColor.black.cgColor
        filterView.layer.shadowOpacity = 0.3
        filterView.layer.shadowOffset = CGSize(width: 0, height: 4)
        filterView.layer.shadowRadius = 6.0
        filterView.layer.masksToBounds = false
    }
    
    
    func btnDeleteModify(){
        btnDelete.layer.cornerRadius = 10.0
        btnDelete.layer.shadowColor = UIColor.black.cgColor
        btnDelete.layer.shadowOpacity = 0.3
        btnDelete.layer.shadowOffset = CGSize(width: 0, height: 4)
        btnDelete.layer.shadowRadius = 6.0
        btnDelete.layer.masksToBounds = false
    }
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        audioFileURL = documentsPath.appendingPathComponent("tts_output.txt")
//
//        do {
//            // Configure and prepare output file
//            outputFile = try AVAudioFile(forWriting: audioFileURL!, settings: audioEngine.outputNode.outputFormat(forBus: 0).settings)
//            print("Text converted to speech. Audio saved at: \(audioFileURL!)")
//        } catch {
//            print("Failed to save audio file: \(error.localizedDescription)")
//        }
//    }
    
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: selectedLanguage)
        utterance.rate = rate
        utterance.pitchMultiplier = pich
        utterance.volume = volume
        utterance.preUtteranceDelay = delay

        synthesizer.speak(utterance)
    }
    
    
    func createLanguageMenu() -> UIMenu {
        var actions: [UIAction] = [] // Specify that actions is of type [UIAction]
        for language in textToSpeechViewModel.languages {
                    print(language.title)
                    actions.append(UIAction(title: language.title, handler: optionClosure()))
                }
        
//        actions = textToSpeechViewModel.languages.map{ language in
//            UIAction(title: language.title, handler: optionClosure())
//            
//        }
        
        return UIMenu(title: "Choose Language", options: .displayInline,children: actions)
    }
    
    func optionClosure() -> UIActionHandler {
        let optionClosure = {(action: UIAction) in
            for language in self.textToSpeechViewModel.languages {
                if language.title == action.title && language.title != "Select Language"{
                    self.selectedLanguage = language.value
                    self.voice = language.message
                    print("language " + self.selectedLanguage)
                    // Exit the loop once found
                }
            }
        }
        return optionClosure
    }
    

}
