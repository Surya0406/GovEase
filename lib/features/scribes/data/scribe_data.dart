class ScribeStep {
  final int stepNumber;
  final String title;
  final String description;
  final String url;
  final String? tipText;
  final String? imagePath;

  const ScribeStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.url = 'uidai.gov.in',
    this.tipText,
    this.imagePath,
  });
}

class Scribe {
  final String id;
  final String title;
  final String subtitle;
  final String iconLetter;
  final String stepsCount;
  final String duration;
  final String level;
  final String overviewDescription;
  final List<ScribeStep> steps;

  const Scribe({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconLetter,
    required this.stepsCount,
    required this.duration,
    required this.level,
    required this.overviewDescription,
    required this.steps,
  });
}

// Sample Data for all Scribes
final sampleScribes = [
  // 1. Aadhaar Enrolment
  Scribe(
    id: 'aadhaar',
    title: 'Aadhaar Enrolment',
    subtitle: 'UIDAI',
    iconLetter: 'अ',
    stepsCount: '6 steps',
    duration: '12 min',
    level: 'Beginner',
    overviewDescription:
        'A screen-by-screen walkthrough of the real portal, so you know exactly what to click before you sit down to actually apply.',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Search UIDAI',
        description: 'Search for "uidai aadhaar" on Google and click on the official link (https://uidai.gov.in).',
        url: 'google.com',
        tipText: 'This is the official government site — check the URL carefully.',
        imagePath: 'assets/images/scribes/aadhaar/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: "Find 'Book an Appointment'",
        description: "Hover over the 'My Aadhaar' menu on the homepage and click 'Book an Appointment'.",
        url: 'uidai.gov.in',
        imagePath: 'assets/images/scribes/aadhaar/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: 'Login to Appointment Portal',
        description: 'Enter your Mobile Number or Email ID and the Captcha code shown on the screen.',
        url: 'uidai.gov.in/appointments',
        imagePath: 'assets/images/scribes/aadhaar/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Verify with OTP',
        description: "Click 'Send OTP', then enter the OTP received on your mobile/email and click 'Authenticate with OTP'.",
        url: 'uidai.gov.in/otp-verify',
        imagePath: 'assets/images/scribes/aadhaar/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Select Appointment Type',
        description: "On the Appointment Portal home page, click on 'Centre Appointment' for new enrolment or update services.",
        url: 'uidai.gov.in/appointments-home',
        imagePath: 'assets/images/scribes/aadhaar/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: 'Fill Details & Search Centre',
        description: "Select Resident type, Age category, and 'New Enrolment'. Then, search for an Aadhaar Seva Kendra. After choosing the location, date, and time, a confirmation will be sent.",
        url: 'uidai.gov.in/appointments-search',
        imagePath: 'assets/images/scribes/aadhaar/step6.png',
      ),
    ],
  ),

  // 2. PAN Card Application
  Scribe(
    id: 'pan',
    title: 'PAN Card Application',
    subtitle: 'NSDL / Protean',
    iconLetter: 'P',
    stepsCount: '8 steps',
    duration: '18 min',
    level: 'Beginner',
    overviewDescription:
        'A screen-by-screen walkthrough of the real portal, so you know exactly what to click before you sit down to actually apply.',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Open the e-PAN portal',
        description: 'Go to the Protean (NSDL) e-PAN application page.',
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: 'Select application type',
        description: "Choose 'New PAN – Indian Citizen (Form 49A)'.",
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: 'Choose category',
        description: "Pick 'Individual', then enter your name and date of birth exactly as on your ID proof.",
        url: 'nsdl.gov.in/pan/apply',
        tipText: 'Use your name exactly as printed on your Aadhaar to avoid a mismatch later.',
        imagePath: 'assets/images/scribes/pan/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Add contact details',
        description: 'Enter your email and mobile — your acknowledgment number will be sent here.',
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Link Aadhaar',
        description: 'Enter your Aadhaar number for e-KYC based verification.',
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: 'Submit & note the number',
        description: 'Save the 15-digit acknowledgment number shown on screen.',
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step6.png',
      ),
      ScribeStep(
        stepNumber: 7,
        title: 'Upload documents',
        description: 'Upload your photo, signature, and proof of identity/address.',
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step7.png',
      ),
      ScribeStep(
        stepNumber: 8,
        title: 'e-Sign and pay',
        description: 'Complete Aadhaar e-Sign and pay the application fee to finish.',
        url: 'nsdl.gov.in/pan/apply',
        imagePath: 'assets/images/scribes/pan/step8.png',
      ),
    ],
  ),

  // 3. Voter ID Registration
  Scribe(
    id: 'voter',
    title: 'Voter ID Registration',
    subtitle: 'NVSP / ECI',
    iconLetter: 'V',
    stepsCount: '7 steps',
    duration: '15 min',
    level: 'Beginner',
    overviewDescription:
        'A screen-by-screen walkthrough of the real portal, so you know exactly what to click before you sit down to actually apply.',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Open the NVSP / Voters Portal',
        description: 'Go to voters.eci.gov.in and create a free account.',
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: 'Start Form 6',
        description: "Select 'New Registration for General Electors' if registering for the first time.",
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: 'Enter personal details',
        description: 'Fill your name, date of birth, and gender as per your ID proof.',
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Add address details',
        description: 'Enter your current residential address for the constituency mapping.',
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Upload documents',
        description: 'Upload photo, age proof, and address proof, each under the size limit shown.',
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: "Add relative's EPIC (optional)",
        description: 'If a family member is already registered, add their Voter ID for faster verification.',
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step6.png',
      ),
      ScribeStep(
        stepNumber: 7,
        title: 'Submit & track',
        description: 'Submit the form and note the reference ID to track your application status.',
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step7.png',
      ),
    ],
  ),

  // 4. Driving Licence (Learner's)
  Scribe(
    id: 'dl',
    title: "Driving Licence (Learner's)",
    subtitle: 'Parivahan',
    iconLetter: 'D',
    stepsCount: '7 steps',
    duration: '20 min',
    level: 'Intermediate',
    overviewDescription:
        'A screen-by-screen walkthrough of the real portal, so you know exactly what to click before you sit down to actually apply.',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Open Parivahan Sewa',
        description: "Go to parivahan.gov.in and choose 'Driving Licence Related Services'.",
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: 'Select your state',
        description: 'Pick the state RTO where you want to apply.',
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: "Apply for Learner's Licence",
        description: "Choose 'Apply for Learner Licence' from the services list.",
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Fill Form 2',
        description: 'Enter personal details and the class of vehicle you want to be licensed for.',
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Upload documents',
        description: 'Upload address proof, age proof, and a passport-size photo.',
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: 'Take the online test',
        description: 'Attempt the mock traffic-rules test slot — you need a passing score to proceed.',
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step6.png',
      ),
      ScribeStep(
        stepNumber: 7,
        title: 'Book your slot & pay',
        description: 'Choose an RTO visit slot if needed, and pay the fee to confirm.',
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step7.png',
      ),
    ],
  ),
];
