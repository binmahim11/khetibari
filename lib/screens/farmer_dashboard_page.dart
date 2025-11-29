// farmer_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:khetibari/services/marketplace_service.dart';
import 'package:khetibari/utils/animations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'List New Product',
              'Sell directly to consumers',
              Icons.add_box,
              Colors.green,
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
    Color color,
  ) {
    return PulseAnimation(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$title coming soon!')));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
