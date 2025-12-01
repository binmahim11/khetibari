// voice_commands_page.dart
// Reference page showing all available Bangla voice commands and gestures

import 'package:flutter/material.dart';

class VoiceCommandsReferencePage extends StatefulWidget {
  const VoiceCommandsReferencePage({Key? key}) : super(key: key);

  @override
  State<VoiceCommandsReferencePage> createState() =>
      _VoiceCommandsReferencePageState();
}

class _VoiceCommandsReferencePageState
    extends State<VoiceCommandsReferencePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কমান্ড রেফারেন্স'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation Commands
            _buildSectionTitle('নেভিগেশন কমান্ড (Navigation)'),
            _buildCommandTile('ড্যাশবোর্ড', 'হোম পেজে যান', Icons.home),
            _buildCommandTile(
              'মার্কেটপ্লেস',
              'মার্কেটপ্লেস খুলুন',
              Icons.shopping_cart,
            ),
            _buildCommandTile(
              'ফসল নিবন্ধন',
              'নতুন ফসলের ব্যাচ যুক্ত করুন',
              Icons.agriculture,
            ),
            _buildCommandTile(
              'কীটপতঙ্গ সনাক্ত',
              'কীটপতঙ্গ সনাক্তকরণ খুলুন',
              Icons.bug_report,
            ),
            _buildCommandTile(
              'ঝুঁকি মানচিত্র',
              'ঝুঁকি মানচিত্র দেখুন',
              Icons.map,
            ),
            _buildCommandTile(
              'আবহাওয়া',
              'আবহাওয়ার পূর্বাভাস দেখুন',
              Icons.cloud,
            ),
            const SizedBox(height: 24),

            // Action Commands
            _buildSectionTitle('অ্যাকশন কমান্ড (Actions)'),
            _buildCommandTile(
              'সংরক্ষণ',
              'বর্তমান ফর্ম সংরক্ষণ করুন',
              Icons.save,
            ),
            _buildCommandTile('সাবমিট', 'ফর্ম জমা দিন', Icons.check_circle),
            _buildCommandTile('বাতিল', 'ফর্ম বাতিল করুন', Icons.cancel),
            _buildCommandTile(
              'মুছে ফেলুন',
              'নির্বাচিত আইটেম মুছুন',
              Icons.delete,
            ),
            _buildCommandTile('শোনান', 'পাঠ্য জোরে পড়ুন', Icons.volume_up),
            const SizedBox(height: 24),

            // Gesture Commands
            _buildSectionTitle('অঙ্গভঙ্গি নিয়ন্ত্রণ (Touchless Gestures)'),
            _buildGestureTile(
              'ডান দিকে সোয়াইপ',
              'পরবর্তী পৃষ্ঠায় যান',
              '→ সোয়াইপ',
            ),
            _buildGestureTile(
              'বাম দিকে সোয়াইপ',
              'আগের পৃষ্ঠায় যান',
              '← সোয়াইপ',
            ),
            _buildGestureTile(
              'উপরের দিকে সোয়াইপ',
              'উপরে স্ক্রোল করুন',
              '↑ সোয়াইপ',
            ),
            _buildGestureTile(
              'নিচের দিকে সোয়াইপ',
              'নিচে স্ক্রোল করুন',
              '↓ সোয়াইপ',
            ),
            _buildGestureTile('থাম্বস আপ', 'অনুমোদন / হ্যাঁ', '👍 থাম্বস আপ'),
            _buildGestureTile('থাম্বস ডাউন', 'অস্বীকার / না', '👎 থাম্বস ডাউন'),
            const SizedBox(height: 24),

            // Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'টিপস & ট্রিকস',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip('স্পষ্টভাবে কথা বলুন - নিশ্চিত করুন মাইক কাজ করছে'),
                  _buildTip('পরিবেশের শব্দ কমান সঠিক স্বীকৃতির জন্য'),
                  _buildTip('ধাপে ধাপে নির্দেশনা অনুসরণ করুন'),
                  _buildTip(
                    'ভয়েস ফিডব্যাক শুনুন নিশ্চিত করতে কমান্ড গৃহীত হয়েছে',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _buildCommandTile(String command, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    command,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureTile(String gesture, String action, String display) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(display, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gesture,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tip, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
