// landing_page.dart

import 'package:flutter/material.dart';
import 'package:khetibari/utils/constants.dart';
import 'package:khetibari/utils/animations.dart';
import 'package:khetibari/screens/marketplace_page.dart';
import 'package:khetibari/screens/login.dart';
import 'package:khetibari/screens/signup.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.getTranslation('app_title')),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // A1: Problem Narrative
            SlideInAnimation(
              child: Container(
                padding: EdgeInsets.all(24.0),
                color: Colors.red.shade50,
                child: Column(
                  children: [
                    Text(
                      Constants.getTranslation('problem_heading'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      Constants.getTranslation('loss_statistic'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 30),
                    _buildLossTimerMetaphor(),
                  ],
                ),
              ),
            ),

            // A1: Solution Pitch & CTA
            SlideInAnimation(
              beginOffset: const Offset(0, 0.5),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    ScaleAnimation(
                      child: Icon(
                        Icons.eco,
                        size: 60,
                        color: Colors.green.shade600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Constants.getTranslation('solution_heading'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      Constants.getTranslation('harvest_guard_pitch'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 40),
                    // Auth buttons (Login & Signup)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.blue.shade700,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.orange.shade700,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Direct Marketplace (available pre-auth)
                    SlideInAnimation(
                      beginOffset: const Offset(0.5, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarketplacePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.storefront),
                        label: const Text('Direct Marketplace'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          backgroundColor: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A1: Visual Metaphor Implementation
  Widget _buildLossTimerMetaphor() {
    return Column(
      children: [
        Text(
          Constants.getTranslation('food_loss_today'),
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        // Loss Progress Bar
        LinearProgressIndicator(
          value: 0.34,
          minHeight: 15,
          backgroundColor: Colors.red.shade100,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade600),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(color: Colors.green)),
            Text(
              Constants.getTranslation('loss_percent'),
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('100%', style: TextStyle(color: Colors.red)),
          ],
        ),
      ],
    );
  }
}
