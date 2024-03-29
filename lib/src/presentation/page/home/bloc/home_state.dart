part of 'home_bloc.dart';


enum HomeCategoryType {
  all('전체보기'),
  mentoringRequest('멘토링 요청'),
  mentoring('멘토링 제안');

  final String title;

  const HomeCategoryType(this.title);
}

class HomeState extends Equatable {
  const HomeState({
    this.selectedHomeCategroyId = 0,
    this.list = const <PostResponse>[]
  });

  final int selectedHomeCategroyId;
  final List<PostResponse> list;

  HomeState copyWith({
    int? selectedHomeCategroyId,
    List<PostResponse>? list
  }) => HomeState(
    selectedHomeCategroyId: selectedHomeCategroyId ?? this.selectedHomeCategroyId,
    list: list ?? this.list
  );

  @override
  List<Object?> get props => [selectedHomeCategroyId, list];
}