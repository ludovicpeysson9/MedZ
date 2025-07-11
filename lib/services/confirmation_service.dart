import 'dart:math';
import 'package:flutter/material.dart';

class ConfirmationService {
  static Future<bool> showConfirmationDialog(BuildContext context) async {
    final randomCode = Random().nextInt(900) + 100; // Génère un code entre 100 et 999
    final controller = TextEditingController();
    bool isCodeCorrect = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Validation requise'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Pour valider l\'action, renseignez ce code : $randomCode'),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isCodeCorrect = value == randomCode.toString();
                    });
                  },
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                onPressed: isCodeCorrect ? () => Navigator.of(context).pop(true) : null,
                child: const Text('Valider'),
              ),
            ],
          ),
        );
      },
    ).then((value) => value ?? false);
  }
}
