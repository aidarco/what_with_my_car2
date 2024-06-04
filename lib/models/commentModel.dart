class CommentModel {
  final String userId;
  final String userName;
  final String text;
  final bool isHelpful;
  DateTime date;

  CommentModel({
    required this.userId,
    required this.userName,
    required this.text,
    required this.date,
    this.isHelpful = false, // По умолчанию isHelpful будет false
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'],
      userName: map['userName'],
      text: map['text'],
      date: map['date'].toDate(),
      isHelpful: map['isHelpful'] ?? false, // Получаем значение isHelpful из map, если оно присутствует, иначе false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'text': text,
      'date': date,
      'isHelpful': isHelpful,
    };
  }
}