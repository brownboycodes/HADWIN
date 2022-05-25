

int calcDaysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours ~/ 24);
}

int calcSecondsBetween(DateTime from, DateTime to) {
  from = DateTime(
      from.year, from.month, from.day, from.hour, from.minute, from.second);
  to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
  return to.difference(from).inSeconds;
}

String customGroup(DateTime transactionDate) {
  String response = '';
  DateTime latestDate = DateTime.now();
  int nDaysInBetween = calcDaysBetween(transactionDate, latestDate);
 
  int years = nDaysInBetween ~/ 365;

  if (years == 1) {
    response = 'Last year';
  } else if (years > 1 && years <= 5) {
    response = '$years years ago';
  } else if (years > 5) {
    response = 'More than 5 years ago';
  } else {
    nDaysInBetween -= 365 * years;
    
    int months = nDaysInBetween ~/ 30;
    if (months == 1) {
      response = 'Last month';
    } else if (months > 1 && months <= 6) {
      response = '$months months ago';
    } else if (months >= 6) {
      response = 'More than 6 months ago';
    } else {
      int days = latestDate.day - transactionDate.day;

      if (days == 1) {
        response = 'Yesterday';
        
        
      } else if (days > 1 && days <= 7) {
        response = 'This week';
      } else if (days > 7 && days <= 14) {
        response = 'Last week';
      } else if (days > 14 && days <= 30) {
        int weeks = days ~/ 7;
        response = '$weeks weeks ago';
      } else {
        response = 'Today';
      }
    }
  }
  return response;
}

int customGroupComparator(String group1, String group2) {
  int comparison = -1;
  int group1Match = 0;
  int group2Match = 0;
  List<String> dateGroups = [
    r'Today',
    r'Yesterday',
    r'This week',
    r'Last week',
    r'\d{1} weeks ago',
    r'Last month',
    r'\d{1} months ago',
    r'More than 6 months ago',
    r'Last year',
    r'\d{1} years ago',
    r'More than 5 years ago',
  ];

  for (var i = 0; i < dateGroups.length; i++) {
    if (RegExp(dateGroups[i]).hasMatch(group1)) {
      group1Match = i;
    }
    if (RegExp(dateGroups[i]).hasMatch(group2)) {
      group2Match = i;
    }
  }
  // check
  if (group1Match == group2Match) {
    comparison = group1.compareTo(group2);
  } else if (group1Match < group2Match) {
    comparison = -1;
  } else {
    comparison = 1;
  }
  return comparison;
}

String dateFormatter(String dateGroup, DateTime transactionDate) {
  String formattedDate = '';
  if (dateGroup == 'Today') {
    formattedDate = _formatTime1(transactionDate);
  } else if (dateGroup == 'Yesterday') {
    formattedDate =
        "Yesterday at ${formatTime2(transactionDate.hour, transactionDate.minute)}";
  } else {
    formattedDate =
        "${transactionDate.day}-${transactionDate.month}-${transactionDate.year} at ${formatTime2(transactionDate.hour, transactionDate.minute)}";
  }
  return formattedDate;
}

String formatTime2(int hrs, int mins) {
  int newHrs = 0;
  String midDayStatus = '';
  String minutesAsString=mins<10?"0$mins":"$mins";
  if (hrs > 12 && hrs < 24) {
    midDayStatus = 'PM';
    newHrs = hrs - 12;
  } else if (hrs == 12 && mins > 0) {
    midDayStatus = 'PM';
    newHrs = 12;
  } else if (hrs < 12) {
    midDayStatus = 'AM';
    newHrs = hrs;
  } else if (hrs == 24) {
    midDayStatus = 'AM';
    newHrs = 00;
  }

  return "$newHrs:$minutesAsString $midDayStatus";
}

String formatTime3(String date) {
  DateTime someDate = DateTime.parse(date);
  int hrs = someDate.hour;
  dynamic mins = someDate.minute;
  int newHrs = 0;
  String midDayStatus = '';

  if (hrs > 12 && hrs < 24) {
    midDayStatus = 'PM';
    newHrs = hrs - 12;
  } else if (hrs == 12 && mins > 0) {
    midDayStatus = 'PM';
    newHrs = 12;
  } else if (hrs < 12) {
    midDayStatus = 'AM';
    newHrs = hrs;
  } else if (hrs == 24) {
    midDayStatus = 'AM';
    newHrs = 00;
  }

  if (mins<=9) {
    mins="0$mins";
  }

  return "$newHrs:$mins $midDayStatus";
}

String _formatTime1(DateTime transactionDate) {
  DateTime latestDate = DateTime.now();

  int seconds = calcSecondsBetween(transactionDate, latestDate);

  int minutes = seconds ~/ 60;
  int hours = minutes ~/ 60;

  String response = '';
  if (hours == 1) {
    response = 'an hour ago';
  } else if (hours > 1 && hours < 24) {
    response = '$hours hours ago';
  } else {
    if (minutes > 30) {
      response = 'half an hour ago';
    } else if (minutes <= 30 && minutes > 1) {
      response = '$minutes minutes ago';
    } else if (minutes == 1) {
      response = 'a minute ago';
    } else {
      if (seconds <= 0) {
        response = 'just now';
      } else if (seconds == 1) {
        response = 'a second ago';
      } else {
        response = '$seconds seconds ago';
      }
    }
  }
  return response;
}


String dateToWords(DateTime transactionDate) {
  String day = _formatDay(transactionDate.day);
  String month = _findMonthInWords(transactionDate.month);
  return "$day $month, ${transactionDate.year}";
}

//? FUNCTION FOR RETRIEVING ORDINALS
String _formatDay(int day) {
  String suffix = '';
  if (day >= 11 && day<=13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }
  return "$day$suffix";
}

String _findMonthInWords(int month) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[month - 1];
}
