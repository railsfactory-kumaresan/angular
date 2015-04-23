if(typeof(Quill) == "undefined") {
     Quill = {};
}

Quill.Config = {
    "supportedLanguages": {
        "bengali": ["বাংলা", "type...", "ટાઇપ...", "beta"],
        "gujarati": ["ગુજરાતી", "type...", "ટાઇપ...", "beta"],
        "hindi": ["हिन्दी", "kya kar rahe hain aap", "क्या कर रहे हैं आप?"],
        "kannada": ["ಕನ್ನಡ", "enu maduttiddira?", "ಏನು ಮಾಡುತ್ತಿದ್ದೀರಾ?"],
        "malayalam": ["മലയാളം", "", ""],
        "marathi": ["मराठी", "tu kasa aahes?", "तू कसा आहेस?"],
        "tamil": ["தமிழ்", "eppadi irukkeenga?", "எப்படி இருக்கீங்க"],
        "telugu": ["తెలుగు", "meeru ela unnaru?", "మీరు ఎలా ఉన్నారు?"],
        "english": ["English", "How are you?", "How are you?"],
        "punjabi": ["","",""]
    },
    "fonts": {
        "bengali": "Vrinda",
        "gujarati": "Shruti",
        "hindi": "Mangal",
        "kannada": "Tunga",
        "marathi": "Mangal",
        "malayalam": "Kartika",
        "tamil": "Latha",
        "telugu": "Gautami",
        "punjabi": "Shruti"
    },
    "fontSizes": {
        "bengali": ["20px", "25px"],
        "malayalam": ["16px", "20px"],
        "hindi": ["12px", "20px"]
    },
    "searchMsgs": {
        "bengali": "Type in bengali and search",
        "gujarati": "Type in Gujarati and search",
        "punjabi": "Type in Punjabi and search",
        "hindi": "हिन्दी मे टाइप करके खोजे",
        "kannada": "ಕನ್ನಡದಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ ಹುಡುಕಿ",
        "marathi": "मराठी मध्ये टाइप करून शोधा",
        "malayalam": "Type in Malayalam and search",
        "tamil": "தமிழில் தட்டச்சு செய்து தேடவும்",
        "telugu": "తెలుగులో టైప్ చేసి వెతకండి",
        "english": "Type here and search"
    },
    "initMsgs": {
        "bengali": "type ...",
        "gujarati": "type ...",
        "punjabi": "type ...",
        "hindi": "idhar type kijiye",
        "marathi": "ithe type kara",
        "kannada": "illi type madi",
        "tamil": "inge type seyyavum",
        "telugu": "ikkada type cheyyandi",
        "malayalam": "ivide type cheyyuga"
    },
    "cache": {
        "version": "02"
    },
    "server": { 
        "version": "3.58",
        "location": "https://api.quillpad.in",
        "processWord": "/processWordJSON", 
        "reverseTrans": "/reverseProcessWordJSON", 
        "getScript": "/getScript", 
        "archiveSearch": "/new/backend/archiveSearchString", 
        "correct": "", 
        "quillPath": "langMaps", 
        "folder": "/new", 
        "domain": "" 
    },  
    "client": {
        "maxWordOptions": 4,
        "version": "2.10",
        "keyboard": {
            "cursorColor": "#A4C1EF",
            "hintColor": "#D1FF7F"
        },
        "scriptReq": true,
        "showOptionPanel":true,
        "default_InscriptMode":false,
        "charlimit": 2000,
        "showKeyboard" :true,
        "maxFailedRequest" : 5,
        "maxWaitTime" : 5,//Seconds
        "netFailureMessage" : "Unable to reach server",
        "netFailureStyle" : "'background-color:#111111; color:white; float:right; font-size:13px; font-weight:bold; opacity:0.8; padding:2px; position:relative; top:-18px;'",
        "defaultLanguage" :"english",
        "preFill": '<SPAN style="font-family: sans-serif; font-size: 10px; color: #888">Type here in <b><i>your</i></b> language.</SPAN>'
    }
};

