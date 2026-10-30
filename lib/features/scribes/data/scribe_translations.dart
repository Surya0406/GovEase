class ScribeStepTranslation {
  final String title;
  final String description;
  final String? tipText;

  const ScribeStepTranslation({
    required this.title,
    required this.description,
    this.tipText,
  });
}

class ScribeTranslations {
  ScribeTranslations._();

  // Language Codes: 'en' (English), 'hi' (Hindi), 'ta' (Tamil)
  static const Map<String, Map<String, Map<int, ScribeStepTranslation>>> _translations = {
    'hi': {
      'aadhaar': {
        1: ScribeStepTranslation(
          title: 'यूआईडीएआई खोजें',
          description: 'गूगल पर "uidai aadhaar" खोजें और आधिकारिक लिंक (https://uidai.gov.in) पर क्लिक करें।',
          tipText: 'यह आधिकारिक सरकारी वेबसाइट है — यूआरएल की ध्यान से जांच करें।',
        ),
        2: ScribeStepTranslation(
          title: "'अपॉइंटमेंट बुक करें' खोजें",
          description: "होमपेज पर 'माई आधार' मेनू पर जाएं और 'अपॉइंटमेंट बुक करें' पर क्लिक करें।",
        ),
        3: ScribeStepTranslation(
          title: 'अपॉइंटमेंट पोर्टल पर लॉगिन करें',
          description: 'अपना मोबाइल नंबर या ईमेल आईडी और स्क्रीन पर दिखाया गया कैप्चा कोड दर्ज करें।',
        ),
        4: ScribeStepTranslation(
          title: 'ओटीपी से सत्यापित करें',
          description: "'ओटीपी भेजें' पर क्लिक करें, फिर अपने मोबाइल/ईमेल पर प्राप्त ओटीपी दर्ज करें और 'ओटीपी के साथ सत्यापित करें' पर क्लिक करें।",
        ),
        5: ScribeStepTranslation(
          title: 'अपॉइंटमेंट प्रकार चुनें',
          description: "अपॉइंटमेंट पोर्टल के मुख्य पृष्ठ पर, नए नामांकन या अपडेट सेवाओं के लिए 'सेंटर अपॉइंटमेंट' पर क्लिक करें।",
        ),
        6: ScribeStepTranslation(
          title: 'विवरण भरें और केंद्र खोजें',
          description: "निवासी का प्रकार, आयु वर्ग और 'नया नामांकन' चुनें। फिर आधार सेवा केंद्र खोजें। स्थान, तिथि और समय चुनने के बाद पुष्टि भेजी जाएगी।",
        ),
      },
      'pan': {
        1: ScribeStepTranslation(
          title: 'प्रोटीन पैन खोजें',
          description: 'गूगल पर "protean pan card" खोजें और आधिकारिक "ऑनलाइन पैन आवेदन" लिंक पर क्लिक करें।',
        ),
        2: ScribeStepTranslation(
          title: 'आवेदन प्रकार चुनें',
          description: "नया आवेदन टैब के तहत 'आवेदन प्रकार चुनें' ड्रॉपडाउन पर क्लिक करें।",
        ),
        3: ScribeStepTranslation(
          title: 'व्यक्तिगत (Individual) चुनें',
          description: "ड्रॉपडाउन सूची से 'INDIVIDUAL' का चयन करें।",
          tipText: 'भविष्य में विसंगति से बचने के लिए अपने आधार पर छपे नाम का ही उपयोग करें।',
        ),
        4: ScribeStepTranslation(
          title: 'संपर्क विवरण जोड़ें',
          description: 'आवेदक जानकारी पर स्क्रॉल करें और अपना ईमेल आईडी और मोबाइल नंबर दर्ज करें।',
        ),
        5: ScribeStepTranslation(
          title: 'आधार लिंक करें',
          description: 'अपने आधार नंबर के अंतिम चार अंक दर्ज करें और पैन कार्ड पर अपनी आधार फोटो प्रिंट करने के लिए हां चुनें।',
        ),
        6: ScribeStepTranslation(
          title: 'पावती संख्या नोट करें',
          description: 'सबमिट पर क्लिक करें और भविष्य के संदर्भ के लिए अपना 15 अंकों का पावती नंबर नोट करें।',
        ),
        7: ScribeStepTranslation(
          title: 'दस्तावेज़ अपलोड करें',
          description: 'मैनुअल दस्तावेज़ अपलोड चुनें, अपलोड पर क्लिक करें और अपने सहायक दस्तावेज़ संलग्न करें।',
        ),
        8: ScribeStepTranslation(
          title: 'ई-साइन और भुगतान करें',
          description: 'ई-साइन के लिए अपना 12 अंकों का आधार दर्ज करें, ओटीपी प्राप्त करें पर क्लिक करें, फिर भुगतान विधि चुनें।',
        ),
      },
      'voter': {
        1: ScribeStepTranslation(
          title: 'एनवीएसपी खोजें',
          description: 'गूगल पर "nvsp" खोजें और आधिकारिक "नागरिक सेवा पोर्टल" लिंक पर क्लिक करें।',
        ),
        2: ScribeStepTranslation(
          title: 'फॉर्म 6 शुरू करें',
          description: "नया मतदाता पंजीकरण अनुभाग के तहत 'फॉर्म 6 भरें' पर क्लिक करें।",
        ),
        3: ScribeStepTranslation(
          title: 'राज्य और जिला चुनें',
          description: "ड्रॉपडाउन से अपना राज्य, जिला और विधानसभा/संसदीय निर्वाचन क्षेत्र चुनें।",
        ),
        4: ScribeStepTranslation(
          title: 'व्यक्तिगत विवरण दर्ज करें',
          description: "व्यक्तिगत विवरण पर क्लिक करें। अपना पहला नाम और उपनाम अपने आधार कार्ड के अनुसार दर्ज करें।",
        ),
        5: ScribeStepTranslation(
          title: 'फ़ोटो अपलोड करें',
          description: "एक पासपोर्ट आकार का रंगीन फ़ोटो अपलोड करें।",
        ),
        6: ScribeStepTranslation(
          title: 'रिश्तेदारों का विवरण जोड़ें',
          description: "किसी एक रिश्तेदार का नाम और उपनाम चुनें और दर्ज करें।",
        ),
        7: ScribeStepTranslation(
          title: 'संपर्क विवरण जोड़ें',
          description: "संपर्क विवरण चुनें और अपना मोबाइल नंबर दर्ज करें।",
        ),
        8: ScribeStepTranslation(
          title: 'वर्तमान पता दर्ज करें',
          description: "वर्तमान पता विवरण चुनें और अपना पूरा आवासीय पता भरें।",
        ),
        9: ScribeStepTranslation(
          title: 'पता प्रमाण अपलोड करें',
          description: "पते के प्रमाण के लिए वैध दस्तावेज़ चुनें और अपलोड करें।",
        ),
        10: ScribeStepTranslation(
          title: 'आवेदन सबमिट करें',
          description: "कैप्चा कोड दर्ज करें और 'पूर्वावलोकन और सबमिट करें' पर क्लिक करें।",
        ),
      },
      'dl': {
        1: ScribeStepTranslation(
          title: 'परिवहन खोजें',
          description: 'गूगल पर "parivahan" खोजें और आधिकारिक लिंक पर क्लिक करें।',
        ),
        2: ScribeStepTranslation(
          title: 'अपना राज्य चुनें',
          description: 'परिवहन सेवा होमपेज पर, आगे बढ़ने के लिए ड्रॉपडाउन मेनू से अपना राज्य चुनें।',
        ),
        3: ScribeStepTranslation(
          title: 'लर्नर लाइसेंस के लिए आवेदन करें',
          description: "सेवा डैशबोर्ड से 'लर्नर लाइसेंस के लिए आवेदन करें' पर क्लिक करें।",
        ),
        4: ScribeStepTranslation(
          title: 'व्यक्तिगत विवरण भरें',
          description: 'नाम, संबंध, राज्य, पिनकोड और मोबाइल नंबर सहित अपना व्यक्तिगत विवरण दर्ज करें।',
        ),
        5: ScribeStepTranslation(
          title: 'दस्तावेज़ अपलोड करें',
          description: "अपने आवश्यक प्रमाण दस्तावेज़ संलग्न करने के लिए 'दस्तावेज़ अपलोड करें' पर क्लिक करें।",
        ),
        6: ScribeStepTranslation(
          title: 'ऑनलाइन परीक्षा दें',
          description: "अपने ट्रैफ़िक नियमों के परीक्षण का प्रयास करने के लिए ऑनलाइन एलएल टेस्ट चुनें।",
        ),
        7: ScribeStepTranslation(
          title: 'अपना स्लॉट बुक करें',
          description: 'कैलेण्डर से उपलब्ध तिथि और समय स्लॉट चुनें और बुक स्लॉट पर क्लिक करें।',
        ),
        8: ScribeStepTranslation(
          title: 'भुगतान के लिए आगे बढ़ें',
          description: 'लेन-देन विवरण की समीक्षा करें और भुगतान के लिए आगे बढ़ें पर क्लिक करें।',
        ),
      },
    },
    'ta': {
      'aadhaar': {
        1: ScribeStepTranslation(
          title: 'UIDAI ஐத் தேடுங்கள்',
          description: 'கூகிளில் "uidai aadhaar" என்று தேடி அதிகாரப்பூர்வ இணைப்பைக் கிளிக் செய்க (https://uidai.gov.in).',
          tipText: 'இது அதிகாரப்பூர்வ அரசு வலைத்தளம் — முகவரியை கவனமாக சரிபார்க்கவும்.',
        ),
        2: ScribeStepTranslation(
          title: "'முன்பதிவு செய்' என்பதைக் கண்டறியவும்",
          description: "முகப்புப்பக்கத்தில் 'My Aadhaar' மெனுவில் 'Book an Appointment' என்பதைக் கிளிக் செய்க.",
        ),
        3: ScribeStepTranslation(
          title: 'போர்ட்டலில் உள்நுழைக',
          description: 'உங்கள் மொபைல் எண் மற்றும் திரையில் உள்ள கேப்ட்சா குறியீட்டை உள்ளிடவும்.',
        ),
        4: ScribeStepTranslation(
          title: 'OTP மூலம் சரிபார்க்கவும்',
          description: "'Send OTP' என்பதைக் கிளிக் செய்து, மொபைலில் வந்த OTP ஐ உள்ளிட்டு சரிபார்க்கவும்.",
        ),
        5: ScribeStepTranslation(
          title: 'சந்திப்பு வகையைத் தேர்ந்தெடுக்கவும்',
          description: "புதிய சேர்க்கை அல்லது புதுப்பிப்பு சேவைகளுக்கு 'Centre Appointment' என்பதைக் கிளிக் செய்க.",
        ),
        6: ScribeStepTranslation(
          title: 'விவரங்களை நிரப்பி மையத்தைத் தேடவும்',
          description: "இருப்பிடம், தேதி மற்றும் நேரத்தைத் தேர்ந்தெடுத்த பிறகு உறுதிப்படுத்தல் அனுப்பப்படும்.",
        ),
      },
      'pan': {
        1: ScribeStepTranslation(
          title: 'புரோட்டீன் பான் தேடுங்கள்',
          description: 'கூகிளில் "protean pan card" என்று தேடி அதிகாரப்பூர்வ இணைப்பைக் கிளிக் செய்க.',
        ),
        2: ScribeStepTranslation(
          title: 'விண்ணப்ப வகையைத் தேர்ந்தெடுக்கவும்',
          description: "'Select Application Type' கீழ்தோன்றும் மெனுவைக் கிளிக் செய்க.",
        ),
        3: ScribeStepTranslation(
          title: 'தனிநபர் (Individual) என்பதைத் தேர்ந்தெடுக்கவும்',
          description: "பட்டியலிலிருந்து 'INDIVIDUAL' என்பதைத் தேர்ந்தெடுக்கவும்.",
        ),
        4: ScribeStepTranslation(
          title: 'தொடர்பு விவரங்களைச் சேர்க்கவும்',
          description: 'உங்கள் மின்னஞ்சல் ஐடி மற்றும் மொபைல் எண்ணை உள்ளிடவும்.',
        ),
        5: ScribeStepTranslation(
          title: 'ஆதாரை இணைக்கவும்',
          description: 'உங்கள் ஆதார் எண்ணின் கடைசி நான்கு இலக்கங்களை உள்ளிடவும்.',
        ),
        6: ScribeStepTranslation(
          title: 'ஒப்புகை எண்ணைக் குறிக்கவும்',
          description: 'சமர்ப்பி என்பதைக் கிளிக் செய்து 15 இலக்க ஒப்புகை எண்ணைக் குறிக்கவும்.',
        ),
        7: ScribeStepTranslation(
          title: 'ஆவணங்களைப் பதிவேற்றவும்',
          description: 'ஆவணப் பதிவேற்றத்தைத் தேர்ந்தெடுத்து சான்று ஆவணங்களை இணைக்கவும்.',
        ),
        8: ScribeStepTranslation(
          title: 'மின்-கையொப்பம் மற்றும் கட்டணம்',
          description: 'ஆதார் மூலம் OTP பெற்று கட்டணத்தைச் செலுத்தவும்.',
        ),
      },
      'voter': {
        1: ScribeStepTranslation(
          title: 'NVSP ஐத் தேடுங்கள்',
          description: 'கூகிளில் "nvsp" என்று தேடி அதிகாரப்பூர்வ இணைப்பைக் கிளிக் செய்க.',
        ),
        2: ScribeStepTranslation(
          title: 'படிவம் 6 ஐத் தொடங்கவும்',
          description: "'Fill Form 6' என்பதைக் கிளிக் செய்க.",
        ),
        3: ScribeStepTranslation(
          title: 'மாநிலம் மற்றும் மாவட்டத்தைத் தேர்ந்தெடுக்கவும்',
          description: "உங்கள் மாநிலம் மற்றும் மாவட்டத்தைத் தேர்ந்தெடுக்கவும்.",
        ),
        4: ScribeStepTranslation(
          title: 'தனிப்பட்ட விவரங்களை உள்ளிடவும்',
          description: "உங்கள் பெயரை ஆதாரில் உள்ளவாறு உள்ளிடவும்.",
        ),
        5: ScribeStepTranslation(
          title: 'புகைப்படத்தைப் பதிவேற்றவும்',
          description: "பாஸ்போர்ட் அளவு புகைப்படத்தைப் பதிவேற்றவும்.",
        ),
        6: ScribeStepTranslation(
          title: 'உறவினர் விவரங்களைச் சேர்க்கவும்',
          description: "உறவினரின் பெயரை உள்ளிடவும்.",
        ),
        7: ScribeStepTranslation(
          title: 'தொடர்பு விவரங்களை உள்ளிடவும்',
          description: "உங்கள் மொபைல் எண்ணை உள்ளிடவும்.",
        ),
        8: ScribeStepTranslation(
          title: 'முகவரியை உள்ளிடவும்',
          description: "உங்கள் முழுமையான குடியிருப்பு முகவரியை நிரப்பவும்.",
        ),
        9: ScribeStepTranslation(
          title: 'முகவரிச் சான்றைப் பதிவேற்றவும்',
          description: "செல்லுபடியாகும் முகவரிச் சான்று ஆவணத்தைப் பதிவேற்றவும்.",
        ),
        10: ScribeStepTranslation(
          title: 'விண்ணப்பத்தைச் சமர்ப்பிக்கவும்',
          description: "கேப்ட்சாவை உள்ளிட்டு சமர்ப்பிக்கவும்.",
        ),
      },
      'dl': {
        1: ScribeStepTranslation(
          title: 'பரிவாஹனைத் தேடுங்கள்',
          description: 'கூகிளில் "parivahan" என்று தேடி அதிகாரப்பூர்வ இணைப்பைக் கிளிக் செய்க.',
        ),
        2: ScribeStepTranslation(
          title: 'மாநிலத்தைத் தேர்ந்தெடுக்கவும்',
          description: 'முகப்புப்பக்கத்தில் உங்கள் மாநிலத்தைத் தேர்ந்தெடுக்கவும்.',
        ),
        3: ScribeStepTranslation(
          title: 'பழகுநர் உரிமத்திற்கு விண்ணப்பிக்கவும்',
          description: "'Apply for Learner Licence' என்பதைக் கிளிக் செய்க.",
        ),
        4: ScribeStepTranslation(
          title: 'தனிப்பட்ட விவரங்களை நிரப்பவும்',
          description: 'பெயர், மொபைல் எண் மற்றும் தகவல்களை உள்ளிடவும்.',
        ),
        5: ScribeStepTranslation(
          title: 'ஆவணங்களைப் பதிவேற்றவும்',
          description: "சான்று ஆவணங்களை இணைக்க பதிவேற்று என்பதைக் கிளிக் செய்க.",
        ),
        6: ScribeStepTranslation(
          title: 'ஆன்லைன் தேர்வை எழுதவும்',
          description: "ஆன்லைன் போக்குவரத்து விதித் தேர்வை எழுதவும்.",
        ),
        7: ScribeStepTranslation(
          title: 'நேரத்தை முன்பதிவு செய்யவும்',
          description: 'தேதி மற்றும் நேரத்தைத் தேர்ந்தெடுத்து முன்பதிவு செய்யவும்.',
        ),
        8: ScribeStepTranslation(
          title: 'கட்டணம் செலுத்தவும்',
          description: 'விவரங்களைச் சரிபார்த்து கட்டணத்தைச் செலுத்தவும்.',
        ),
      },
    },
  };

  static ScribeStepTranslation getTranslation({
    required String langCode, // 'en', 'hi', 'ta'
    required String scribeId,
    required int stepNumber,
    required ScribeStepTranslation defaultEnglish,
  }) {
    if (langCode == 'en') return defaultEnglish;

    final langMap = _translations[langCode];
    if (langMap == null) return defaultEnglish;

    final scribeMap = langMap[scribeId];
    if (scribeMap == null) return defaultEnglish;

    final translation = scribeMap[stepNumber];
    return translation ?? defaultEnglish;
  }
}
