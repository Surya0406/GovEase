import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/scribe_data.dart';
import '../data/scribe_translations.dart';
import '../services/voice_guidance_service.dart';
import 'scribe_complete_screen.dart';

class ScribeWalkthroughScreen extends StatefulWidget {
  final Scribe scribe;

  const ScribeWalkthroughScreen({
    super.key,
    required this.scribe,
  });

  @override
  State<ScribeWalkthroughScreen> createState() => _ScribeWalkthroughScreenState();
}

class _ScribeWalkthroughScreenState extends State<ScribeWalkthroughScreen> {
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    VoiceGuidanceService.instance.addListener(_onVoiceStateChanged);
  }

  @override
  void dispose() {
    VoiceGuidanceService.instance.removeListener(_onVoiceStateChanged);
    VoiceGuidanceService.instance.stop();
    super.dispose();
  }

  void _onVoiceStateChanged() {
    if (mounted) setState(() {});
  }

  void _speakCurrentStep(ScribeStepTranslation translation) async {
    final textToSpeak = '${translation.title}. ${translation.description}';
    final success = await VoiceGuidanceService.instance.speak(textToSpeak);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice guidance language unavailable on device. Falling back to default.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final steps = widget.scribe.steps;
    final currentStep = steps[_currentStepIndex];
    final progress = (_currentStepIndex + 1) / steps.length;

    final voiceService = VoiceGuidanceService.instance;
    final currentLang = voiceService.selectedLanguage;

    final translation = ScribeTranslations.getTranslation(
      langCode: currentLang,
      scribeId: widget.scribe.id,
      stepNumber: currentStep.stepNumber,
      defaultEnglish: ScribeStepTranslation(
        title: currentStep.title,
        description: currentStep.description,
        tipText: currentStep.tipText,
      ),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? Colors.white : AppColors.primary),
                    onPressed: () {
                      voiceService.stop();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.lightBlue.shade50,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_currentStepIndex + 1}/${steps.length}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Multilingual Voice Guidance Audio Control Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    voiceService.ttsState == TtsState.playing
                        ? Icons.volume_up
                        : Icons.spatial_audio_off,
                    color: Colors.blue.shade700,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Voice Guide:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Language Switcher Chips
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _langChip('English', 'en', currentLang),
                          const SizedBox(width: 4),
                          _langChip('हिंदी', 'hi', currentLang),
                          const SizedBox(width: 4),
                          _langChip('தமிழ்', 'ta', currentLang),
                        ],
                      ),
                    ),
                  ),

                  // Audio Control Buttons
                  if (voiceService.ttsState == TtsState.playing)
                    IconButton(
                      icon: const Icon(Icons.pause, color: Colors.blue),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => voiceService.pause(),
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.play_arrow, color: Colors.blue.shade700),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _speakCurrentStep(translation),
                    ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.replay, color: Colors.grey, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _speakCurrentStep(translation),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mock Web Browser Card
                    _buildMockBrowser(currentStep, isDark),
                    const SizedBox(height: 24),

                    // STEP X Indicator
                    Text(
                      'STEP ${currentStep.stepNumber}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Step Title (Localized)
                    Text(
                      translation.title,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Step Description (Localized)
                    Text(
                      translation.description,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Optional Tip Box
                    if (translation.tipText != null || currentStep.tipText != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : const Color(0xFFEBF7FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                translation.tipText ?? currentStep.tipText!,
                                style: TextStyle(
                                  color: isDark ? Colors.white : AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _currentStepIndex == 0
                  ? _buildNextButton(isFullWidth: true)
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              voiceService.stop();
                              setState(() {
                                _currentStepIndex--;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue.shade200),
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildNextButton(isFullWidth: false),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _langChip(String label, String code, String currentLang) {
    final isSelected = currentLang == code;
    return GestureDetector(
      onTap: () {
        VoiceGuidanceService.instance.setLanguage(code);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton({required bool isFullWidth}) {
    final isLastStep = _currentStepIndex == widget.scribe.steps.length - 1;

    return ElevatedButton(
      onPressed: () {
        VoiceGuidanceService.instance.stop();
        if (isLastStep) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScribeCompleteScreen(scribe: widget.scribe),
            ),
          );
        } else {
          setState(() {
            _currentStepIndex++;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        isLastStep ? 'Finish scribe' : 'Next step',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMockBrowser(ScribeStep step, bool isDark) {
    if (step.imagePath != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                step.imagePath!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${step.stepNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : const Color(0xFFF4F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Row(
                  children: const [
                    CircleAvatar(radius: 4, backgroundColor: Color(0xFFFF5F56)),
                    SizedBox(width: 4),
                    CircleAvatar(radius: 4, backgroundColor: Color(0xFFFFBD2E)),
                    SizedBox(width: 4),
                    CircleAvatar(radius: 4, backgroundColor: Color(0xFF27C93F)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, size: 12, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          step.url,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2EFF6)),
          Container(
            padding: const EdgeInsets.all(20),
            height: 180,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade300,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 12,
                  top: 14,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${step.stepNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
