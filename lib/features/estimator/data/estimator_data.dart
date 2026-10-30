class EligibilityQuestion {
  final String id;
  final String questionText;
  final bool requiredAnswer; // true for Yes, false for No

  const EligibilityQuestion({
    required this.id,
    required this.questionText,
    this.requiredAnswer = true,
  });
}

class ServiceEstimatorData {
  final String serviceId;
  final String serviceName;
  final String department;
  final String applicationFee;
  final String serviceCharges;
  final String totalEstimatedCost;
  final String processingTime;
  final String lastUpdatedDate;
  final String officialSource;
  final List<EligibilityQuestion> eligibilityQuestions;
  final List<String> requiredDocuments;

  const ServiceEstimatorData({
    required this.serviceId,
    required this.serviceName,
    required this.department,
    required this.applicationFee,
    required this.serviceCharges,
    required this.totalEstimatedCost,
    required this.processingTime,
    required this.lastUpdatedDate,
    required this.officialSource,
    required this.eligibilityQuestions,
    required this.requiredDocuments,
  });
}

final Map<String, ServiceEstimatorData> serviceEstimatorDataMap = {
  'aadhaar': const ServiceEstimatorData(
    serviceId: 'aadhaar',
    serviceName: 'Aadhaar Enrolment',
    department: 'UIDAI (Unique Identification Authority of India)',
    applicationFee: '₹0 (Free for New Enrolment)',
    serviceCharges: '₹0',
    totalEstimatedCost: 'Free',
    processingTime: '7 – 15 Working Days',
    lastUpdatedDate: 'November 2026',
    officialSource: 'uidai.gov.in',
    eligibilityQuestions: [
      EligibilityQuestion(id: 'q1', questionText: 'Are you an Indian resident or NRI holding a valid passport?'),
      EligibilityQuestion(id: 'q2', questionText: 'Have you lived in India for 182 days or more in the past 12 months?'),
      EligibilityQuestion(id: 'q3', questionText: 'Do you have valid proof of identity and proof of address documents?'),
    ],
    requiredDocuments: [
      'Proof of Identity (Passport, PAN, Voter ID, Ration Card)',
      'Proof of Address (Utility Bill, Bank Statement, Passport)',
      'Proof of Date of Birth (Birth Certificate, SSLC Marksheet)',
    ],
  ),
  'pan': const ServiceEstimatorData(
    serviceId: 'pan',
    serviceName: 'PAN Card Application',
    department: 'Income Tax Department (Protean NSDL / UTIITSL)',
    applicationFee: '₹91 (Application Fee) + 18% GST',
    serviceCharges: '₹19 (Dispatch Charge for Physical Card)',
    totalEstimatedCost: '₹110 (Indian Address) / ₹1,020 (Foreign Address)',
    processingTime: '10 – 15 Working Days',
    lastUpdatedDate: 'November 2026',
    officialSource: 'incometax.gov.in / protean-tinpan.com',
    eligibilityQuestions: [
      EligibilityQuestion(id: 'q1', questionText: 'Are you an Indian citizen, NRI, or registered entity requiring a Tax Identifier?'),
      EligibilityQuestion(id: 'q2', questionText: 'Do you have a valid Aadhaar number for instant e-KYC/e-Sign?'),
    ],
    requiredDocuments: [
      'Aadhaar Card (for e-KYC and instant e-Sign)',
      'Passport-size Color Photograph (if applying via manual upload)',
      'Proof of Identity & Address (if Aadhaar e-KYC is not selected)',
    ],
  ),
  'voter': const ServiceEstimatorData(
    serviceId: 'voter',
    serviceName: 'Voter ID Registration (Form 6)',
    department: 'Election Commission of India (ECI / NVSP)',
    applicationFee: '₹0 (Free Application)',
    serviceCharges: '₹0',
    totalEstimatedCost: 'Free',
    processingTime: '15 – 30 Working Days',
    lastUpdatedDate: 'November 2026',
    officialSource: 'voters.eci.gov.in',
    eligibilityQuestions: [
      EligibilityQuestion(id: 'q1', questionText: 'Are you a citizen of India?'),
      EligibilityQuestion(id: 'q2', questionText: 'Will you be 18 years or older as of 1st January of the qualifying year?'),
      EligibilityQuestion(id: 'q3', questionText: 'Are you an ordinary resident of the constituency where you are registering?'),
    ],
    requiredDocuments: [
      'Passport-size Color Photograph (4.5cm x 3.5cm, white background)',
      'Proof of Age (Birth Certificate, Aadhaar, PAN, SSLC Marksheet)',
      'Proof of Residence (Electricity Bill, Water Bill, Bank Passbook, Aadhaar)',
    ],
  ),
  'dl': const ServiceEstimatorData(
    serviceId: 'dl',
    serviceName: "Driving Licence (Learner's)",
    department: 'Ministry of Road Transport and Highways (Parivahan Sewa)',
    applicationFee: '₹150 (Learner Licence Fee) + ₹50 (Test Fee)',
    serviceCharges: '₹0',
    totalEstimatedCost: '₹200 (Varies slightly by State RTO rules)',
    processingTime: '7 – 14 Working Days',
    lastUpdatedDate: 'November 2026',
    officialSource: 'parivahan.gov.in / sarathi.parivahan.gov.in',
    eligibilityQuestions: [
      EligibilityQuestion(id: 'q1', questionText: 'Are you aged 18 or older? (Aged 16+ for gearless motor cycles up to 50cc)'),
      EligibilityQuestion(id: 'q2', questionText: 'Are you aware of basic traffic signals, road safety rules, and signages?'),
      EligibilityQuestion(id: 'q3', questionText: 'Do you hold valid proof of age and proof of residence?'),
    ],
    requiredDocuments: [
      'Proof of Age (Aadhaar, Birth Certificate, School Certificate)',
      'Proof of Address (Aadhaar, Voter ID, Passport, Utility Bill)',
      'Medical Certificate Form 1-A (for applicants aged 40+ or commercial vehicles)',
      'Passport-size Color Photograph',
    ],
  ),
};
