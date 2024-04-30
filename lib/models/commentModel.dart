class CommentModel {
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;
  final bool isHelpful;

  CommentModel({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
    this.isHelpful = false, // По умолчанию isHelpful будет false
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'],
      userName: map['userName'],
      userAvatar: map['userAvatar'],
      text: map['text'],
      isHelpful: map['isHelpful'] ?? false, // Получаем значение isHelpful из map, если оно присутствует, иначе false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
      'isHelpful': isHelpful,
    };
  }
}