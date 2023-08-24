List<PLanActualModel> planActualModelFromJson(List data) =>
    List<PLanActualModel>.from(
      data.map(
        (x) => PLanActualModel.fromJson(x),
      ),
    );

class PLanActualModel {
  PLanActualModel({
    required this.name,
    required this.value,
  });

  String name;
  int value;

  factory PLanActualModel.fromJson(Map<String, dynamic> json) =>
      PLanActualModel(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
