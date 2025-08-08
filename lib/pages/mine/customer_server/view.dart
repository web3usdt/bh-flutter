import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/style/theme.dart';
import 'package:BBIExchange/pages/mine/customer_server/Controller.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CustomerServerPage extends GetView<CustomerServerController> {
  const CustomerServerPage({super.key});

  // 占位符链接，请替换为您的真实链接
  final String _telegramUrl = 'https://www.teltlk.com/#/register?invite=HAPPYxfb';
  final String _potatoUrl = 'https://www.teltlk.com/#/register?invite=dtac38606';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerServerController>(
      init: CustomerServerController(),
      builder: (_) {
        return Scaffold(
          appBar: TDNavBar(
            title: '联系客服'.tr,
            titleFontWeight: FontWeight.w600,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              _buildLinkCard(
                icon: Icons.telegram,
                title: '${'国际小微'.tr}1',
                onTap: () => controller.launchURL(_telegramUrl),
                iconColor: const Color(0xFF2AABEE),
              ),
              const SizedBox(height: 16),
              _buildLinkCard(
                icon: Icons.chat_bubble_outline,
                title: '${'国际小微'.tr}2',
                onTap: () => controller.launchURL(_potatoUrl),
                iconColor: const Color(0xFFF9A825),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.blockTwoBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.color000,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.color999,
            ),
          ],
        ),
      ),
    );
  }
}
