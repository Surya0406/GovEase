import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/scribe_data.dart';
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
  Widget build(BuildContext context) {
    final steps = widget.scribe.steps;
    final currentStep = steps[_currentStepIndex];
    final progress = (_currentStepIndex + 1) / steps.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  // Progress Bar
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.lightBlue.shade50,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Step fraction e.g. 3/7
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

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mock Web Browser Card
                    _buildMockBrowser(currentStep),
                    const SizedBox(height: 28),

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

                    // Step Title
                    Text(
                      currentStep.title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Step Description
                    Text(
                      currentStep.description,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Optional Tip Box
                    if (currentStep.tipText != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF7FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                currentStep.tipText!,
                                style: const TextStyle(
                                  color: AppColors.primary,
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

            // Bottom Buttons Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _currentStepIndex == 0
                  ? _buildNextButton(isFullWidth: true)
                  : Row(
                      children: [
                        // Back Button
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
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
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Next Step / Finish Scribe Button
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

  Widget _buildNextButton({required bool isFullWidth}) {
    final isLastStep = _currentStepIndex == widget.scribe.steps.length - 1;

    return ElevatedButton(
      onPressed: () {
        if (isLastStep) {
          // Open Full-screen Completion Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ScribeCompleteScreen(),
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

  Widget _buildMockBrowser(ScribeStep step) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Column(
        children: [
          // Browser Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Red, Yellow, Green window dots
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
                // URL bar
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, size: 12, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          step.url,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
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

          // Browser Page Content Illustration
          Container(
            padding: const EdgeInsets.all(20),
            height: 180,
            child: Stack(
              children: [
                // Image or Wireframe
                if (step.imagePath != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        step.imagePath!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                else
                  // Wireframe skeleton
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
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
                      // Dashed Highlight Box
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

                // Step Number Badge
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
