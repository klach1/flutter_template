enum EventCategory {
  prihlasene('prihlasene', 'Přihlášené'),
  spolkove('spolkove', 'Spolkové'),
  otevrene('otevrene', 'Otevřené');

  const EventCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static EventCategory fromString(String value) {
    return EventCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => EventCategory.otevrene,
    );
  }
}
