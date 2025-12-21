String formatDateFr(String date) {
  try {
    final dateTime = DateTime.parse(date);
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  } catch (e) {
    return date;
  }
}

String formatDateFrShort(String date) {
  try {
    final dateTime = DateTime.parse(date);
    const months = [
      'jan',
      'fév',
      'mar',
      'avr',
      'mai',
      'juin',
      'juil',
      'août',
      'sep',
      'oct',
      'nov',
      'déc',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  } catch (e) {
    return date;
  }
}
