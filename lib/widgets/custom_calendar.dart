import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum CalendarType { day, month, year }

class CustomCalendar extends StatelessWidget {
  final CalendarType type;

  const CustomCalendar({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toLanguageTag(); 
    String topText;
    String bottomText;

    switch (type) {
      case CalendarType.day:
        topText = DateFormat.MMM(locale).format(now).toUpperCase(); 
        bottomText = DateFormat('dd', locale).format(now);
        break;
      case CalendarType.month:
        topText = DateFormat.y(locale).format(now); 
        bottomText = DateFormat.MMM(locale).format(now).toUpperCase();
        break;
      case CalendarType.year:
        topText = 'YEAR'; 
        bottomText = DateFormat.y(locale).format(now);
        break;
    }

    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                topText,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'ArchiveBlack',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bottomText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: 'KumarOne',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
