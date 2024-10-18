class UnbordingContent {
  String image;

  String description;

  UnbordingContent({required this.image, required this.description});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      image: 'images/community.png',
      description: "Create Post Comment, Poll Whenever and wherever you want"),
  UnbordingContent(
      image: 'images/poll.png',
      description: "Find Fun and Interesting poll to Boost your knowledge"),
  UnbordingContent(
      image: 'images/post.png',
      description: "Like and Comment the Post together with your friends"),
];
