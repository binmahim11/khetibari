// farmer_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:khetibari/services/marketplace_service.dart';
import 'package:khetibari/utils/animations.dart';
import 'package:khetibari/utils/app_button_styles.dart';
import 'package:khetibari/utils/animated_farmer_graphics.dart';
import 'package:khetibari/screens/risk_map';
import 'package:khetibari/screens/pest_identification_page.dart';
import 'package:khetibari/screens/voice_interface_widget.dart';
import 'package:khetibari/screens/crop_batch_page.dart';
import 'package:khetibari/screens/marketplace_page.dart';
import 'package:khetibari/screens/list_new_product.dart';

class FarmerDashboardPage extends StatefulWidget {
  final String farmerId;

  const FarmerDashboardPage({super.key, required this.farmerId});

  @override
  State<FarmerDashboardPage> createState() => _FarmerDashboardPageState();
}

class _FarmerDashboardPageState extends State<FarmerDashboardPage> {
  final _marketplaceService = MarketplaceService();
  late double totalEarnings;
  late double commissionSaved;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    totalEarnings = _marketplaceService.getFarmerTotalEarnings(widget.farmerId);
    commissionSaved = _marketplaceService.getTotalCommissionSaved(
      widget.farmerId,
    );
  }

  // Handle voice commands
  void _handleVoiceCommand(String command) {
    switch (command) {
      case 'crop_batch':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CropBatchPage()),
        );
        break;
      case 'marketplace':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MarketplacePage()),
        );
        break;
      case 'pest_identification':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PestIdentificationPage(farmerId: widget.farmerId),
          ),
        );
        break;
      case 'risk_map':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RiskMapPage(farmerId: widget.farmerId),
          ),
        );
        break;
      case 'home':
        // Already on home, show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('আপনি ইতিমধ্যে ড্যাশবোর্ডে আছেন')),
        );
        break;
      case 'logout':
        _showLogoutDialog();
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('অজানা কমান্ড: $command')));
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('লগআউট করুন?'),
            content: const Text('আপনি কি সত্যিই লগআউট করতে চান?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('বাতিল'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Text('লগআউট'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khetibari Dashboard'),
        backgroundColor: Colors.black,
        elevation: 4,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voice Interface
            VoiceInterfaceWidget(
              onCommandReceived: _handleVoiceCommand,
              enableGestures: true,
            ),
            const SizedBox(height: 16),

            // Animated Farmer Graphic Header
            Center(
              child: AnimatedFarmerGraphic(
                type: 'farmer',
                width: 160,
                height: 160,
                animationType: 'slideUp',
                duration: const Duration(milliseconds: 1200),
              ),
            ),
            const SizedBox(height: 16),

            // Key Metrics
            SlideInAnimation(
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Total Earnings',
                      '৳${totalEarnings.toStringAsFixed(2)}',
                      Colors.green.shade600,
                      Icons.attach_money,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      'Commission Saved',
                      '৳${commissionSaved.toStringAsFixed(2)}',
                      Colors.blue.shade600,
                      Icons.savings,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Direct Sales Info
            SlideInAnimation(
              beginOffset: const Offset(0.5, 0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber.shade700),
                        const SizedBox(width: 12),
                        Text(
                          'Direct Sales Advantage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '✓ 100% of earnings go directly to you\n'
                      '✓ No middleman commission (typically 20-30%)\n'
                      '✓ Direct connection with consumers\n'
                      '✓ Dynamic pricing based on demand\n'
                      '✓ Build customer loyalty',
                      style: TextStyle(height: 1.8),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            SlideInAnimation(
              beginOffset: const Offset(0, 0.5),
              child: Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Community Risk Map',
              'View spoilage threats in your district',
              Icons.map,
              Colors.red,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RiskMapPage(farmerId: widget.farmerId),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              'পোকা চিহ্নিতকরণ',
              'AI দ্বারা পোকা সনাক্ত করুন এবং সমাধান পান',
              Icons.bug_report,
              Colors.orange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            PestIdentificationPage(farmerId: widget.farmerId),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              'List New Product',
              'Sell directly to consumers',
              Icons.add_box,
              Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ListNewProductPage(
                          farmerId: widget.farmerId,
                          farmerName: 'রফিকুল ফার্ম', // TODO: Get from auth
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              'View My Products',
              'Manage your listings',
              Icons.shopping_bag,
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              'Orders & Transactions',
              'Track your sales',
              Icons.receipt_long,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return ScaleAnimation(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return PulseAnimation(
      child: Container(
        decoration: AppButtonStyles.cardDecoration(
          backgroundColor: Colors.black,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                onTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title coming soon!'),
                      backgroundColor: Colors.black,
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
