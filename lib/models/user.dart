class User {
  String userName = "";
  String userImagePath = "";

  User(String userName, String userImagePath) {
    this.userName = userName;
    this.userImagePath = userImagePath;
  }

  User.Clone(User user) : this(user.userName, user.userImagePath);
}
