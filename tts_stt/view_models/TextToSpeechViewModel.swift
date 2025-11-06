//
//  TextToSpeechViewModel.swift
//  mood_capture
//
//  Created by MacBook on 04/11/24.
//

import Foundation

class TextToSpeechViewModel: ObservableObject{
    var languages = [
        Language(title: "Hindi", value: "hi-IN", message: "Hello, how are you?"),
        Language(title: "English (US)", value: "en-US",message: "Hello, how are you?"),
        Language(title: "English (UK)", value: "en-GB",message: "Hello, how are you?"),
        Language(title: "Spanish (Spain)", value: "es-ES",message: "Hello, how are you?"),
        Language(title: "Spanish (Mexico)", value: "es-MX",message: "Hello, how are you?"),
        Language(title: "French (France)", value: "fr-FR",message: "Hello, how are you?"),
        Language(title: "French (Canada)", value: "fr-CA", message: "Hello, how are you?"),
        Language(title: "German", value: "de-DE", message: "Hello, how are you?"),
        Language(title: "Italian", value: "it-IT", message: "Hello, how are you?"),
        Language(title: "Japanese", value: "ja-JP", message: "Hello, how are you?"),
        Language(title: "Korean", value: "ko-KR", message: "Hello, how are you?"),
        Language(title: "Chinese (Simplified)", value: "zh-CN",message: "Hello, how are you?"),
        Language(title: "Chinese (Traditional)", value: "zh-TW",message: "Hello, how are you?"),
        Language(title: "Arabic", value: "ar-SA",message: "Hello, how are you?"),
        Language(title: "Portuguese (Brazil)", value: "pt-BR", message: "Hello, how are you?"),
        Language(title: "Portuguese (Portugal)", value: "pt-PT", message: "Hello, how are you?"),
        Language(title: "Russian", value: "ru-RU", message: "Hello, how are you?"),
        
    ]
}
