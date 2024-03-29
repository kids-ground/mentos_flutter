import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentos_flutter/src/data/dto/response/post/post_response.dart';
import 'package:mentos_flutter/src/presentation/page/home/bloc/home_bloc.dart';
import 'package:mentos_flutter/src/presentation/page/request_modify/view/request_modify_page.dart';
import 'package:mentos_flutter/src/presentation/page/request_post_detail/view/request_post_detail_page.dart';
import 'package:mentos_flutter/src/presentation/style/text_style.dart';
import 'package:mentos_flutter/src/presentation/widget/app_bar/app_bar.dart';
import 'package:mentos_flutter/src/presentation/widget/button/line_check_button.dart';
import 'package:mentos_flutter/src/presentation/style/color_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mentos_flutter/src/util/constant/date.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        bottomLine: false,
        leadingWidth: 200,
        leading: Row(
          children: [
            Image.asset(
              "assets/images/mentos_question.png",
              width: 24,
            ),
            const SizedBox(width: 8,),
            Text(
              '멘티 요청',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _ActionButton(),
      body: Container(
        child: const Column(
          children: [
            // _CategoryListView(),
            Divider(
              height: 0.2,
              thickness: 0.2,
              color: black300,
            ),
            _ContentListView()
          ],
        ),
      )
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      minSize: 0,
      onPressed: () {
        Navigator.push(context, RequestModifyPage.route());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            color: blue200,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                spreadRadius: 4,
                color: black800,
                blurRadius: 4,
                offset: Offset(1, 1)
              )
            ]
        ),
        child: Image.asset(
          "assets/images/pencil.png",
          color: mainColor,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}



class _CategoryListView extends StatelessWidget {
  const _CategoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloC = context.read<HomeBloc>();

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (pre, cur) => pre.selectedHomeCategroyId != cur.selectedHomeCategroyId,
      builder: (context, state) => Container(
        height: 12 + 12 + 32,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: HomeCategoryType.values.length,
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          itemBuilder: (context, index) => LineCheckButton(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            title: HomeCategoryType.values[index].title,
            fontSize: 16,
            isSelected: index == state.selectedHomeCategroyId,
            onPressed: () {
              homeBloC.add(HomeSelectCategory(selectedHomeCategroyId: index));
            },
          )
        ),
      ),
    );
  }
}

class _ContentListView extends StatelessWidget {
  const _ContentListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (Platform.isAndroid) {
          return Expanded(
            child: RefreshIndicator(
              color: white,
              onRefresh: () {
                context.read<HomeBloc>().add(const HomeLoadPostListEvent());
                return Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) => _ContentListItem(data: state.list[index],)
              ),
            ),
          );
        } else {
          return Expanded(
            child: Container(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () {
                      context.read<HomeBloc>().add(const HomeLoadPostListEvent());
                      return Future.delayed(const Duration(milliseconds: 500));
                    },
                  ),
                  const SliverPadding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16),),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: state.list.length,
                      (context, index) => Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,16),
                        child: _ContentListItem(data: state.list[index],),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}

class _ContentListItem extends StatelessWidget {
  const _ContentListItem({
    Key? key,
    required this.data
  }) : super(key: key);

  final PostResponse data;

  final double width = 30;
  final double height = 30;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: BorderRadius.circular(16),
      onPressed: () {
        Navigator.push(context, RequestPostDetailPage.route(data.postId));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: black800,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileView(),
            const SizedBox(height: 16,),
            buildContentView(),
            const SizedBox(height: 16,),
            buildFooter()
          ],
        )
      ),
    );
  }

  Widget buildProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          width: width,
          height: height,
          imageUrl: data.writer!.thumbnailUrl!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              color: blue300,
              borderRadius: BorderRadius.all(Radius.circular(width/2)),
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  scale: 0.5
              ),
            ),
          ),
          placeholder: (context, url) => Container(width: width, height: height,),
        ),
        const SizedBox(width: 8,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.writer!.nickname, style: primaryB4),
            const SizedBox(height: 2,),
            Text(timeAgo(data.createdAt), style: primaryC2,),
          ],
        ),
      ],
    );
  }

  Widget buildContentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: primaryT2,
                ),
                const SizedBox(height: 8,),
                Text(
                  data.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: customColorTextStyle(primaryB2, null, height: 1.5),
                ),
                const SizedBox(height: 12,),
                Row(
                  children: data.tags.map((v) =>
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: red100,
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: Text(
                              '#${v}',
                              style: customColorTextStyle(primaryB4, red1000),
                            ),
                          ),
                          const SizedBox(width: 6,)
                        ],
                      )
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFooter() {
    return Row(
      children: [
        Image.asset('assets/images/eye.png', width: 18, color: white800,),
        const SizedBox(width: 6,),
        Text(
          '${data.hit ?? 0}',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: white1000
          ),
        ),
        const SizedBox(width: 24,),
        Image.asset('assets/images/chat_dots.png', width: 18, color: white800,),
        const SizedBox(width: 6,),
        Text(
          '${data.commentCount ?? 0}',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: white1000
          ),
        ),
      ],
    );
  }
}

// Mock
class MockMember{
  const MockMember({
    required this.nickname,
    required this.company,
    this.isCertified = false,
    required this.thumbnail
  });

  final String nickname;
  final String company;
  final bool isCertified;
  final String thumbnail;
}

class MockMentoringData {
  MockMentoringData({
    required this.category,
    required this.jobDuty,
    required this.member,
    required this.title,
    required this.description,
    required this.tagList,
    required this.hit,
    required this.chatCount,
    this.price = 20000,
    this.thumbnail
  });

  final String category;
  final String jobDuty;
  final MockMember member;
  final String title;
  final String description;
  final List<String> tagList;

  final int hit;
  final int chatCount;
  final int price;
  String? thumbnail;
}


var mockData = [
  MockMentoringData(
    category: "멘토링 제안",
    jobDuty: "소프트웨어 개발",
    member: MockMember(
      nickname: "로건",
      isCertified: true,
      company: "토스",
      thumbnail: "https://avatars.githubusercontent.com/u/52196792?v=4"
    ),
    title: "신입 공채 준비 중인데..",
    description: "신입 공채 준비 중인데 뭐부터 공부해야할지 잘 모르겠어요. 공채 합격자 분들 중 가이드라인을 제시해 주실 분을 찾습니다.",
    tagList:['신입', '네카라'],
    hit: 302,
    chatCount: 3,
  ),

  MockMentoringData(
    category: "멘토링 요청",
    jobDuty: "마케팅",
    member: MockMember(
        nickname: "로건",
        isCertified: true,
        company: "토스",
        thumbnail: "https://avatars.githubusercontent.com/u/52196792?v=4"
    ),
    title: "마케팅에 대해서 배워보고 싶어요",
    description: "개발을 하다보니 마케팅에 관해서도 호기심이 생겼습니다. 저에게 마케팅에 대해서 알려주실 분 없을까요??",
    tagList: ['마케팅', '주니어'],
    hit: 27,
    chatCount: 0,
    thumbnail: "https://i0.wp.com/blog.codestates.com/wp-content/uploads/2023/02/%EC%BD%94%EB%93%9C%EC%8A%A4%ED%85%8C%EC%9D%B4%EC%B8%A0_%ED%8D%BC%ED%8F%AC%EB%A8%BC%EC%8A%A4%EB%A7%88%EC%BC%80%ED%8C%85%EC%9D%B4%EB%9E%80_%EB%8C%80%ED%91%9C%EC%9D%B4%EB%AF%B8%EC%A7%80.png?resize=750%2C485&ssl=1"
  )
];
