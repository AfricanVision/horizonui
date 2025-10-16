enum PaymentType { Income, Expenditure }

class PaymentStatus {
  final String? status;
  final String? color;

  PaymentStatus({this.status, this.color});

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(status: json['status'], color: json['color']);
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'color': color};
  }
}

class Payment {
  final String? id;
  final PaymentType? type;
  final double amount;
  final double amountPaid;
  final String? currency;
  final PaymentStatus? status;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    this.id,
    this.type,
    this.amount = 0.0,
    this.amountPaid = 0.0,
    this.currency,
    this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      type: json['type'] != null
          ? PaymentType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => PaymentType.Income,
            )
          : null,
      amount: (json['amount'] ?? 0.0).toDouble(),
      amountPaid: (json['amountPaid'] ?? 0.0).toDouble(),
      currency: json['currency'],
      status: json['status'] != null
          ? PaymentStatus.fromJson(json['status'])
          : null,
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type?.name,
      'amount': amount,
      'amountPaid': amountPaid,
      'currency': currency,
      'status': status?.toJson(),
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
