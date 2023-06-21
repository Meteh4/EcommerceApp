class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to Shoptral the Shopping App",
    image: "assets/images/image1.png",
    desc: "This app is a demo app made with fake shop API.",
  ),
  OnboardingContents(
    title: "Find the item you are looking for",
    image: "assets/images/image2.png",
    desc:
    "Here you'll see rich varieties of goods, carefully classified for seamless browsing experience.",
  ),
];