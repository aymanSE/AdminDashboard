class Rate {
  int? id;
  int? eventId;
  int? userId;
  int? rate;
  Rate(
    this.id,
    this.eventId,
    this.userId,
    this.rate,
  );
  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      json['id'] ?? 0,
      json['event_id'] ?? 0,
      json['user_id'] ?? 0,
      json['rate'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      'event_id': eventId.toString(),
      'user_id': userId.toString(),
      'rate': rate.toString(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rate &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          eventId == other.eventId;
}
