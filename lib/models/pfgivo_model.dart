import 'dart:convert';

Pfgivo pfgivoFromJson(String str) => Pfgivo.fromJson(json.decode(str));

String pfgivoToJson(Pfgivo data) => json.encode(data.toJson());

List<DataPfgivo> pfgivoModelFromJson(List data) => List<DataPfgivo>.from(
      data.map(
        (x) => DataPfgivo.fromJson(x),
      ),
    );

class Pfgivo {
  Pfgivo({
    required this.status,
    required this.list,
  });

  bool status;
  ListClass list;

  factory Pfgivo.fromJson(Map<String, dynamic> json) => Pfgivo(
        status: json["status"],
        list: ListClass.fromJson(json["list"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "list": list.toJson(),
      };
}

class ListClass {
  ListClass({
    required this.data,
  });

  List<DataPfgivo> data;

  factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
        data: List<DataPfgivo>.from(
            json["data"].map((x) => DataPfgivo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataPfgivo {
  DataPfgivo({
    required this.createdAt,
    required this.updatedAt,
    required this.order,
    required this.stockin,
    required this.totalstock,
    required this.idWorkorder,
    required this.scanned,
    required this.stockout,
    required this.summaryNg,
  });

  DateTime createdAt;
  DateTime updatedAt;
  int order;
  int stockin;
  int totalstock;
  int idWorkorder;
  int scanned;
  int stockout;
  int summaryNg;

  factory DataPfgivo.fromJson(Map<String, dynamic> json) => DataPfgivo(
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        order: json["order"],
        stockin: json["stockin"],
        totalstock: json["totalstock"],
        idWorkorder: json["id_workorder"],
        scanned: json["scanned"],
        stockout: json["stockout"],
        summaryNg: json["summaryNG"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "order": order,
        "stockin": stockin,
        "totalstock": totalstock,
        "id_workorder": idWorkorder,
        "scanned": scanned,
        "stockout": stockout,
        "summaryNG": summaryNg,
      };
}


// import 'dart:convert';

// Pfgivo pfgivoFromJson(String str) => Pfgivo.fromJson(json.decode(str));

// String pfgivoToJson(Pfgivo data) => json.encode(data.toJson());

// List<DataPfgivo> pfgivoModelFromJson(List data) => List<DataPfgivo>.from(
//       data.map(
//         (x) => DataPfgivo.fromJson(x),
//       ),
//     );

// class Pfgivo {
//   Pfgivo({
//     required this.status,
//     required this.data,
//   });

//   bool status;
//   List<DataPfgivo> data;

//   factory Pfgivo.fromJson(Map<String, dynamic> json) => Pfgivo(
//         status: json["status"],
//         data: List<DataPfgivo>.from(
//             json["data"].map((x) => DataPfgivo.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class DataPfgivo {
//   DataPfgivo({
//     required this.datumIn,
//     required this.createdAt,
//     required this.out,
//     required this.stock,
//     required this.id,
//   });

//   DateTime createdAt;
//   int datumIn;
//   int out;
//   int stock;
//   String id;

//   factory DataPfgivo.fromJson(Map<String, dynamic> json) => DataPfgivo(
//         createdAt: DateTime.parse(json["createdAt"]),
//         datumIn: json["in"],
//         out: json["out"],
//         stock: json["stock"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "createdAt": createdAt.toIso8601String(),
//         "in": datumIn,
//         "out": out,
//         "stock": stock,
//         "id": id,
//       };
// }

// To parse this JSON data, do
//
//     final pfgivo = pfgivoFromJson(jsonString);
