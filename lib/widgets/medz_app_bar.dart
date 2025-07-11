import 'package:flutter/material.dart';
import '../screens/medication_screen.dart';     
import '../screens/settings_screen.dart';

class MedzAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const MedzAppBar({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12), 
      color: Colors.teal,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48), 
              
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicationScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'MedZ 💊',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.settings, size: 30, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}
