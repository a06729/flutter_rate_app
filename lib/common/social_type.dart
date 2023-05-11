enum SocialType {
  kakao("kakao"),
  google("google");

  final String text;
  const SocialType(this.text);

  String toString() => text;
}
