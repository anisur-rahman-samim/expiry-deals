class VendorDashboardModel {
  VendorDashboardModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory VendorDashboardModel.fromJson(Map<String, dynamic> json){
    return VendorDashboardModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.totalIncome,
    required this.totalProducts,
    required this.monthlyIncome,
  });

  final double? totalIncome;
  final int? totalProducts;
  final List<MonthlyIncome> monthlyIncome;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      totalIncome: json["totalIncome"],
      totalProducts: json["totalProducts"],
      monthlyIncome: json["monthlyIncome"] == null ? [] : List<MonthlyIncome>.from(json["monthlyIncome"]!.map((x) => MonthlyIncome.fromJson(x))),
    );
  }

}

class MonthlyIncome {
  MonthlyIncome({
    required this.month,
    required this.income,
  });

  final String? month;
  final int? income;

  factory MonthlyIncome.fromJson(Map<String, dynamic> json){
    return MonthlyIncome(
      month: json["month"],
      income: json["income"],
    );
  }

}
