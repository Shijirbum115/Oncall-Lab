import 'package:bugamed/ui/patient/models/review_ui.dart';

const _comments = [
  'Doctor was attentive and explained everything clearly.',
  'Felt very comfortable and heard throughout the appointment.',
  'Quick response time and great bedside manner.',
  'Scheduling was easy and the visit was efficient.',
];

final sampleReviews = List<ReviewUI>.generate(
  _comments.length,
  (index) => ReviewUI(
    name: [
      'Joana Perkins',
      'Paolina Caldicot',
      'Nikolaos Cooksley',
      'Sarah Lee'
    ][index],
    avatarUrl: [
      'https://images.unsplash.com/photo-1504593811423-6dd665756598',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
    ][index],
    comment: _comments[index],
    dateLabel: '1 day ago',
    rating: 4.0 + index * 0.2,
    badgeColor: [
      0xFFffcdcf,
      0xFFccd1fa,
      0xFFf9d8b9,
      0xFFe1edf8,
    ][index],
  ),
);
