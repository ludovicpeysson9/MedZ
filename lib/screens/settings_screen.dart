import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/notification_service.dart';
import '../widgets/medz_app_bar.dart';
import '../l10n/app_localizations.dart';
import '../utils/context_extension.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _entries = await NotificationService.loadNotificationSettings();
    setState(() {});
  }

  Future<void> _pickTime(int index) async {
    final entry = _entries[index];
    final initial = TimeOfDay(
      hour: entry['hour'] as int,
      minute: entry['minute'] as int,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        entry['hour'] = picked.hour;
        entry['minute'] = picked.minute;
      });
    }
  }

  Future<void> _saveSettings() async {
    await NotificationService.updateNotificationTimes(_entries);

    if (!mounted) return;

    try {
      await NotificationService.scheduleNotifications(
        title: context.loc.t(L10nKey.reminder),
        body: context.loc.t(L10nKey.reminderBody),
      );
    } on PlatformException catch (e) {
      debugPrint('Exact alarms not permitted: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.t(L10nKey.exactAlarmsNotPermitted))),
      );
    }

    final activeTimes = _entries.where((e) => e['enabled'] as bool).map((e) {
      final h = (e['hour'] as int).toString().padLeft(2, '0');
      final m = (e['minute'] as int).toString().padLeft(2, '0');
      return '$h:$m';
    }).toList();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.teal),
            const SizedBox(width: 8),
            Text(context.loc.t(L10nKey.confirmed)),
          ],
        ),
        content: activeTimes.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: activeTimes.map((t) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(t, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                }).toList(),
              )
            : Text(
                context.loc.t(L10nKey.noNotifications),
                style: const TextStyle(fontSize: 16),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: Text(context.loc.t(L10nKey.ok)),
          ),
        ],
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Scaffold(
      appBar: MedzAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  loc.t(L10nKey.settingsOfNotifications),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ...List.generate(_entries.length, (i) {
              final entry = _entries[i];
              final hour = entry['hour'] as int;
              final minute = entry['minute'] as int;
              final enabled = entry['enabled'] as bool;
              return Opacity(
                opacity: enabled ? 1.0 : 0.4,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Notification ${i + 1}'),
                  subtitle: Text(
                    '${hour.toString().padLeft(2, '0')}:' +
                        '${minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _pickTime(i),
                      ),
                      Checkbox(
                        value: enabled,
                        onChanged: (v) {
                          setState(() {
                            entry['enabled'] = v ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save, color: Colors.teal),
                label: Text(
                  loc.t(L10nKey.save),
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
