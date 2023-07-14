enum SocialType {
  kakao("kakao"),
  google("google"),
  line("line");

  final String text;
  const SocialType(this.text);

  String toString() => text;
}
