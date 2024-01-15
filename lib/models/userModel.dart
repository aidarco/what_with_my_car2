class UserModel {
  String? name;
  String? description;
  String? id;
  String? problemsDesided;
  String? problemsCreated;

  UserModel(
      {this.name,
        this.description,
        this.id,
        this.problemsDesided,
        this.problemsCreated});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    id = json['id'];
    problemsDesided = json['problemsDesided'];
    problemsCreated = json['problemsCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['id'] = id;
    data['problemsDesided'] = problemsDesided;
    data['problemsCreated'] = problemsCreated;
    return data;
  }
}