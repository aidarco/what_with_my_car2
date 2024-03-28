import 'commentModel.dart';

class ProblemModel {
  final String id;
  final String userId;
  final String description;
  final String problemName;
  final String carMark;
  final String carModel;
  final String problemType;
  final String year;
  final List<String> imageUrls;
  final List<CommentModel> comments;

  ProblemModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.problemName,
    required this.carMark,
    required this.carModel,
    required this.problemType,
    required this.year,
    this.imageUrls = const [],
    this.comments = const [],
  });

  factory ProblemModel.fromMap(Map<String, dynamic> data) {
    return ProblemModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      description: data['description'] as String,
      problemName: data['problemName'] as String,
      carMark: data['carMark'] as String,
      carModel: data['carModel'] as String,
      problemType: data['problemType'] as String,
      year: data['year'] as String,
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      comments: (data['comments'] as List<dynamic>?)
          ?.map((comment) => CommentModel.fromMap(comment))
          .toList() ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'problemName': problemName,
      'carMark': carMark,
      'carModel': carModel,
      'problemType': problemType,
      'year': year,
      'imageUrls': imageUrls, // Include image URLs
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}