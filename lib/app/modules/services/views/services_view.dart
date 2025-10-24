import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/services_controller.dart';

class ServicesView extends GetView<ServicesController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.spa, color: Colors.green.shade600),
                      ),
                      title: Text(service),
                      subtitle: const Text('Professional therapy service'),
                      trailing: ElevatedButton(
                        onPressed: () => controller.bookService(service),
                        child: const Text('Book'),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
