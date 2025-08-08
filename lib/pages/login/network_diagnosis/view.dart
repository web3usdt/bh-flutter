import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'controller.dart';

class NetworkDiagnosisPage extends GetView<NetworkDiagnosisController> {
  const NetworkDiagnosisPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NetworkDiagnosisController());

    return Scaffold(
      appBar: TDNavBar(
        title: '网络诊断',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => ButtonWidget(
                  onTap: controller.isTesting.value ? null : controller.startDiagnosis,
                  text: controller.isTesting.value ? '诊断中...' : '开始诊断',
                )),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Obx(() => SingleChildScrollView(
                      child: Text(controller.diagnosisLog.value),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            ButtonWidget(
              onTap: controller.copyLog,
              text: '复制诊断日志',
            ),
          ],
        ),
      ),
    );
  }
}
