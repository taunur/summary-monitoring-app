import 'dart:convert';

MonRak monRakFromJson(String str) => MonRak.fromJson(json.decode(str));

String monRakToJson(MonRak data) => json.encode(data.toJson());

List<DataRak> dataRakModelFromJson(List data) => List<DataRak>.from(
      data.map(
        (x) => DataRak.fromJson(x),
      ),
    );

List<Supplier> supplierModelFromJson(List data) => List<Supplier>.from(
      data.map(
        (x) => Supplier.fromJson(x),
      ),
    );

class MonRak {
  MonRak({
    required this.status,
    required this.list,
  });

  bool status;
  ListClass list;

  factory MonRak.fromJson(Map<String, dynamic> json) => MonRak(
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

  List<DataRak> data;

  factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
        data: List<DataRak>.from(json["data"].map((x) => DataRak.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataRak {
  DataRak({
    required this.type,
    required this.address,
    required this.supplier,
    required this.used,
    required this.available,
    required this.totalSupplier,
    required this.idStock,
  });

  int idStock;
  String type;
  String address;
  List<Supplier> supplier;
  int used;
  int available;
  int totalSupplier;

  factory DataRak.fromJson(Map<String, dynamic> json) => DataRak(
        type: json["type"],
        address: json["address"],
        supplier: List<Supplier>.from(
            json["supplier"].map((x) => Supplier.fromJson(x))),
        used: json["Used"],
        available: json["Available"],
        totalSupplier: json["Total_Supplier"],
        idStock: json["id_stock"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "address": address,
        "supplier": List<dynamic>.from(supplier.map((x) => x.toJson())),
        "Used": used,
        "Available": available,
        "Total_Supplier": totalSupplier,
        "id": idStock,
      };
}

class Supplier {
  Supplier({
    required this.namaSupplier,
    required this.jumlah,
  });

  String namaSupplier;
  int jumlah;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        namaSupplier: json["nama_supplier"],
        jumlah: json["jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "nama_supplier": namaSupplier,
        "jumlah": jumlah,
      };
}
