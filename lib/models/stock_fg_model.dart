List<StockFGModel> stockModelFromJson(List data) => List<StockFGModel>.from(
      data.map(
        (x) => StockFGModel.fromJson(x),
      ),
    );

class StockFGModel {
  StockFGModel({
    required this.idStock,
    required this.partName,
    required this.qty,
    required this.createdAt,
    required this.updatedAt,
  });

  int idStock;
  String partName;
  int qty;
  String createdAt;
  String updatedAt;

  factory StockFGModel.fromJson(Map<String, dynamic> json) => StockFGModel(
        idStock: json["id_stock"],
        partName: json["partName"],
        qty: json["qty"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_stock": idStock,
        "partName": partName,
        "qty": qty,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class TabelStckFGModel {
  TabelStckFGModel({
    required this.id,
    required this.partId,
    required this.supplier,
    required this.partNumber,
    required this.partName,
    required this.min,
    required this.max,
    required this.inbound,
    required this.outbond,
    required this.sisa,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int partId;
  String supplier;
  String partNumber;
  String partName;
  int min;
  int max;
  int inbound;
  int outbond;
  int sisa;
  String status;
  String createdAt;
  String updatedAt;

  factory TabelStckFGModel.fromJson(Map<String, dynamic> json) =>
      TabelStckFGModel(
        id: json["id"],
        partId: json["part_id"],
        supplier: json["supplier"],
        partNumber: json["part-number"],
        partName: json["part-name"],
        min: json["min"],
        max: json["max"],
        inbound: json["inbound"],
        outbond: json["outbond"],
        sisa: json["sisa"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "part_id": partId,
        "supplier": supplier,
        "part-number": partNumber,
        "part-name": partName,
        "min": min,
        "max": max,
        "inbound": inbound,
        "outbond": outbond,
        "sisa": sisa,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
