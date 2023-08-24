import 'dart:convert';

Mivo mivoFromJson(String str) => Mivo.fromJson(json.decode(str));

String mivoToJson(Mivo data) => json.encode(data.toJson());

List<DataMivo> mivoModelFromJson(List data) => List<DataMivo>.from(
      data.map(
        (x) => DataMivo.fromJson(x),
      ),
    );

class Mivo {
  Mivo({
    required this.data,
  });

  List<DataMivo> data;

  factory Mivo.fromJson(Map<String, dynamic> json) => Mivo(
        data:
            List<DataMivo>.from(json["data"].map((x) => DataMivo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataMivo {
  DataMivo({
    required this.id,
    required this.materialId,
    required this.material,
    required this.day,
    required this.totalIn,
    required this.totalOut,
    required this.totalStock,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int materialId;
  String material;
  List<Day> day;
  int totalIn;
  int totalOut;
  int totalStock;
  String createdAt;
  String updatedAt;

  factory DataMivo.fromJson(Map<String, dynamic> json) => DataMivo(
        id: json["id"],
        materialId: json["material_id"],
        material: json["material"],
        day: List<Day>.from(json["day"].map((x) => Day.fromJson(x))),
        totalIn: json["total_IN"],
        totalOut: json["total_OUT"],
        totalStock: json["total_STOCK"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "material_id": materialId,
        "material": material,
        "day": List<dynamic>.from(day.map((x) => x.toJson())),
        "total_IN": totalIn,
        "total_OUT": totalOut,
        "total_STOCK": totalStock,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Day {
  Day({
    required this.day,
    required this.dayIn,
    required this.out,
  });

  String day;
  int dayIn;
  int out;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        day: json["day"],
        dayIn: json["in"],
        out: json["out"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "in": dayIn,
        "out": out,
      };
}
