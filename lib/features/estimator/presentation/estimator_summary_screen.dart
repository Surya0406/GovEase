import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../scribes/data/scribe_data.dart';
import '../../scribes/presentation/scribe_walkthrough_screen.dart';
import '../data/estimator_data.dart';

class EstimatorSummaryScreen extends StatefulWidget {
  final Scribe scribe;

  const EstimatorSummaryScreen({
    super.key,
    required this.scribe,
  });

  @override
  State<EstimatorSummaryScreen> createState() => _EstimatorSummaryScreenState();
}

class _EstimatorSummaryScreenState extends State<EstimatorSummaryScreen> {
  late final ServiceEstimatorData _data;
  final Map<String, bool> _answers = {};
  final Map<String, bool> _availableDocs = {};

  @override
  void initState() {
    super.initState();
    _data = serviceEstimatorDataMap[widget.scribe.id] ?? serviceEstimatorDataMap['aadhaar']!;

    for (var q in _data.eligibilityQuestions) {
      _answers[q.id] = true; // Default to Yes
    }

    for (var doc in _data.requiredDocuments) {
      _availableDocs[doc] = false;
    }
  }

  String get _eligibilityOutcome {
    int yesCount = _answers.values.where((v) => v == true).length;
    int total = _answers.length;

    if (yesCount == total) {
      return 'Appears Eligible';
    } else if (yesCount >= total - 1) {
      return 'May Require Additional Verification';
    } else {
      return 'Appears Not Eligible';
    }
  }

  Color get _outcomeColor {
    final outcome = _eligibilityOutcome;
    if (outcome == 'Appears Eligible') {
      return Colors.green.shade700;
    } else if (outcome == 'May Require Additional Verification') {
      return Colors.orange.shade800;
    } else {
      return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outcome = _eligibilityOutcome;
    final outcomeColor = _outcomeColor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Fee & Eligibility Estimator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Header
            Card(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data.serviceName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _data.department,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.source, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Source: ${_data.officialSource} • Updated ${_data.lastUpdatedDate}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 1. Eligibility Section
            const Text('1. Eligibility Assessment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._data.eligibilityQuestions.map((q) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.questionText,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('Yes'),
                                  selected: _answers[q.id] == true,
                                  selectedColor: Colors.blue.shade700,
                                  labelStyle: TextStyle(
                                    color: _answers[q.id] == true ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                  onSelected: (selected) {
                                    if (selected) setState(() => _answers[q.id] = true);
                                  },
                                ),
                                const SizedBox(width: 12),
                                ChoiceChip(
                                  label: const Text('No'),
                                  selected: _answers[q.id] == false,
                                  selectedColor: Colors.red.shade700,
                                  labelStyle: TextStyle(
                                    color: _answers[q.id] == false ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                  onSelected: (selected) {
                                    if (selected) setState(() => _answers[q.id] = false);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(child: Text('Assessment Outcome:', style: TextStyle(fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: outcomeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: outcomeColor),
                          ),
                          child: Text(
                            outcome,
                            style: TextStyle(color: outcomeColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Disclaimer: Estimator result is illustrative and does not constitute an official government eligibility decision.',
                      style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Application Fee & Processing Time
            const Text('2. Estimated Fee & Processing Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _costRow('Application Fee', _data.applicationFee),
                    _costRow('Service / Processing Charges', _data.serviceCharges),
                    const Divider(height: 20),
                    _costRow('Total Estimated Cost', _data.totalEstimatedCost, isBold: true),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.timer_outlined, color: Colors.blue),
                              SizedBox(width: 8),
                              Flexible(child: Text('Estimated Duration', style: TextStyle(fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            _data.processingTime,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Document Checklist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text('3. Required Document Checklist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Text(
                  '${_availableDocs.values.where((v) => v).length} / ${_data.requiredDocuments.length} Ready',
                  style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: _data.requiredDocuments.map((docName) {
                  final isChecked = _availableDocs[docName] ?? false;
                  return CheckboxListTile(
                    title: Text(docName, style: const TextStyle(fontSize: 14)),
                    value: isChecked,
                    activeColor: Colors.blue.shade700,
                    onChanged: (val) {
                      setState(() {
                        _availableDocs[docName] = val ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 28),

            // Proceed to Application Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScribeWalkthroughScreen(scribe: widget.scribe),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Proceed to Scribe Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _costRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 15 : 13))),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: isBold ? Colors.blue.shade700 : null),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
