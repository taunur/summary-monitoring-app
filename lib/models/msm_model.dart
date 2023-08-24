class MsmModel {
  MsmModel({
    required this.id,
    required this.supplierId,
    required this.materialReceiveId,
    required this.batchMaterialId,
    required this.actual,
    required this.supplier,
    required this.batchMaterialName,
    required this.type,
    required this.qtyMin,
    required this.qtyMax,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int supplierId;
  int materialReceiveId;
  int batchMaterialId;
  int actual;
  String supplier;
  String batchMaterialName;
  String type;
  int qtyMin;
  int qtyMax;
  DateTime createdAt;
  DateTime updatedAt;

  factory MsmModel.fromJson(Map<String, dynamic> json) => MsmModel(
        id: json["id"],
        supplierId: json["supplier_id"],
        materialReceiveId: json["material_receive_id"],
        batchMaterialId: json["batch_material_id"],
        actual: json["actual"],
        supplier: json["supplier"],
        batchMaterialName: json["batch_material_name"],
        type: json["type"],
        qtyMin: json["qty_min"],
        qtyMax: json["qty_max"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supplier_id": supplierId,
        "material_receive_id": materialReceiveId,
        "batch_material_id": batchMaterialId,
        "actual": actual,
        "supplier": supplier,
        "batch_material_name": batchMaterialName,
        "type": type,
        "qty_min": qtyMin,
        "qty_max": qtyMax,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
