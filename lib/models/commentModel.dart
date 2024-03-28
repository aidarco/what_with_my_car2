class CommentModel {
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;

  CommentModel({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'],
      userName: map['userName'],
      userAvatar: map['userAvatar'],
      text: map['text'],
    );
  }
}