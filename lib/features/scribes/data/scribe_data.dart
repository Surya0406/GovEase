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
  final String? officialPortalUrl;
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
    this.officialPortalUrl,
    required this.steps,
  });
}

// Sample Data for all Scribes with verified official government portal URLs
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
    officialPortalUrl: 'https://uidai.gov.in',
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
    officialPortalUrl: 'https://www.onlineservices.tin.egov-nsdl.com',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Search Protean PAN',
        description: 'Search for "protean pan card" on Google and click on the official "Online PAN application" link.',
        url: 'google.com',
        imagePath: 'assets/images/scribes/pan/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: 'Select Application Type',
        description: "Click on 'Select Application Type' dropdown under the New Application tab.",
        url: 'onlineservices.tin.egov-nsdl.com',
        imagePath: 'assets/images/scribes/pan/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: 'Choose Individual',
        description: "Select 'INDIVIDUAL' from the dropdown list.",
        url: 'onlineservices.tin.egov-nsdl.com',
        tipText: 'Use your name exactly as printed on your Aadhaar to avoid a mismatch later.',
        imagePath: 'assets/images/scribes/pan/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Add Contact Details',
        description: 'Scroll down to Applicant Information and enter your Email ID and Mobile Number.',
        url: 'onlineservices.tin.egov-nsdl.com',
        imagePath: 'assets/images/scribes/pan/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Link Aadhaar',
        description: 'Enter the last four digits of your Aadhaar number and select Yes to agree to have your Aadhaar photo printed on the PAN Card.',
        url: 'onlineservices.tin.egov-nsdl.com',
        imagePath: 'assets/images/scribes/pan/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: 'Note Acknowledgment',
        description: 'Click Submit and note down your 15-digit acknowledgement number for future reference.',
        url: 'onlineservices.tin.egov-nsdl.com',
        imagePath: 'assets/images/scribes/pan/step6.png',
      ),
      ScribeStep(
        stepNumber: 7,
        title: 'Upload Documents',
        description: 'Select Manual Document Upload, click Upload, and attach your supporting documents (PDF format, max 300kb).',
        url: 'onlineservices.tin.egov-nsdl.com',
        imagePath: 'assets/images/scribes/pan/step7.png',
      ),
      ScribeStep(
        stepNumber: 8,
        title: 'e-Sign and Pay',
        description: 'Enter your 12-digit Aadhaar for e-Sign, click Get OTP, then proceed to select a payment method and click Proceed to Payment.',
        url: 'onlineservices.tin.egov-nsdl.com',
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
    stepsCount: '10 steps',
    duration: '20 min',
    level: 'Beginner',
    overviewDescription:
        'A screen-by-screen walkthrough of the real portal, so you know exactly what to click before you sit down to actually apply.',
    officialPortalUrl: 'https://voters.eci.gov.in',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Search NVSP',
        description: 'Search for "nvsp" on Google and click on the official "Citizen Service Portal" link.',
        url: 'google.com',
        imagePath: 'assets/images/scribes/voter/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: 'Start Form 6',
        description: "Click on 'Fill Form 6' under the New Voter Registration section.",
        url: 'voters.eci.gov.in',
        imagePath: 'assets/images/scribes/voter/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: 'Select State & District',
        description: "Select your State, District, and Assembly/Parliamentary Constituency from the dropdowns.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Enter Personal Details',
        description: "Click on 'B. Personal Details'. Enter your First Name and Surname exactly as it appears on your Aadhaar card.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Upload Photograph',
        description: "Upload a passport size color photograph (4.5cm x 3.5cm) showing front view of full face with white background. Max size 2MB.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: 'Add Relatives Details',
        description: "Select 'C. Name and Surname of any one of the relatives'. Choose a relative type and enter their name.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step6.png',
      ),
      ScribeStep(
        stepNumber: 7,
        title: 'Add Contact Details',
        description: "Select 'D. Contact Details' and enter your Mobile Number.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step7.png',
      ),
      ScribeStep(
        stepNumber: 8,
        title: 'Enter Present Address',
        description: "Select 'H. Present Address Details' and fill in your complete residential address.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step8.png',
      ),
      ScribeStep(
        stepNumber: 9,
        title: 'Upload Address Proof',
        description: "Scroll down in the Address section to select and upload a valid Document for Proof of Address.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step9.png',
      ),
      ScribeStep(
        stepNumber: 10,
        title: 'Submit Application',
        description: "Select 'L. Captcha', enter the captcha code shown, and click on 'Preview and Submit'.",
        url: 'voters.eci.gov.in/form6',
        imagePath: 'assets/images/scribes/voter/step10.png',
      ),
    ],
  ),

  // 4. Driving Licence (Learner's)
  Scribe(
    id: 'dl',
    title: "Driving Licence (Learner's)",
    subtitle: 'Parivahan',
    iconLetter: 'D',
    stepsCount: '8 steps',
    duration: '20 min',
    level: 'Intermediate',
    overviewDescription:
        'A screen-by-screen walkthrough of the real portal, so you know exactly what to click before you sit down to actually apply.',
    officialPortalUrl: 'https://parivahan.gov.in',
    steps: const [
      ScribeStep(
        stepNumber: 1,
        title: 'Search Parivahan',
        description: 'Search for "parivahan" on Google and click on the official link (https://parivahan.gov.in).',
        url: 'google.com',
        imagePath: 'assets/images/scribes/dl/step1.png',
      ),
      ScribeStep(
        stepNumber: 2,
        title: 'Select your state',
        description: 'On the Parivahan Sewa homepage, select your state from the dropdown menu to proceed.',
        url: 'parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step2.png',
      ),
      ScribeStep(
        stepNumber: 3,
        title: "Apply for Learner's Licence",
        description: "Click on 'Apply for Learner Licence' from the services dashboard.",
        url: 'sarathi.parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step3.png',
      ),
      ScribeStep(
        stepNumber: 4,
        title: 'Fill Personal Details',
        description: 'Enter your personal details including Name, Relation, State, Pincode, and Mobile Number.',
        url: 'sarathi.parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step4.png',
      ),
      ScribeStep(
        stepNumber: 5,
        title: 'Upload documents',
        description: "Click on 'Upload Document' from the top menu to attach your required proof documents.",
        url: 'sarathi.parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step5.png',
      ),
      ScribeStep(
        stepNumber: 6,
        title: 'Take the online test',
        description: "Go to the Learner Licence menu and select 'Online LL Test(Stall)' to attempt your mock traffic rules test.",
        url: 'sarathi.parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step6.png',
      ),
      ScribeStep(
        stepNumber: 7,
        title: 'Book your slot',
        description: 'Select an available date and time slot from the calendar and click BOOK SLOT.',
        url: 'sarathi.parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step7.png',
      ),
      ScribeStep(
        stepNumber: 8,
        title: 'Proceed for Payment',
        description: 'Review your transaction details, agree to the terms, and click Proceed for Payment to complete the process.',
        url: 'sarathi.parivahan.gov.in',
        imagePath: 'assets/images/scribes/dl/step8.png',
      ),
    ],
  ),
];
