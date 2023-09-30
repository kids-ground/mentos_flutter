import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentos_flutter/src/presentation/page/chat_list/view/chat_list.dart';
import 'package:mentos_flutter/src/presentation/page/home/bloc/home_bloc.dart';
import 'package:mentos_flutter/src/presentation/page/home/view/home.dart';
import 'package:mentos_flutter/src/presentation/page/main_tab/bloc/main_tab_bloc.dart';
import 'package:mentos_flutter/src/presentation/page/mentor_list/view/mentor_list.dart';
import 'package:mentos_flutter/src/presentation/page/setting/view/setting.dart';
import 'package:mentos_flutter/src/util/color/color_style.dart';

class MainTabPage extends StatelessWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()..add(const HomeSelectCategory(selectedHomeCategroyId: 0)))
        // MainTab에 포함되는 Page
      ],
      child: const _MainTabView()
    );
  }
}

class _MainTabView extends StatelessWidget {
  const _MainTabView({Key? key}) : super(key: key);

  final List<_MainTabPageInfo> pageInfoList = const [
    _MainTabPageInfo(page: HomePage(), pageIconPath: "assets/images/home.png", pageName: '홈'),
    _MainTabPageInfo(page: MentorListPage(), pageIconPath: "assets/images/users.png", pageName: '멘토'),
    _MainTabPageInfo(page: ChatListPage(), pageIconPath: "assets/images/chat.png", pageName: '채팅'),
    _MainTabPageInfo(page: SettingPage(), pageIconPath: "assets/images/setting.png", pageName: '설정'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainTabBloc, MainTabState>(
      builder: (context, state) => WillPopScope(
          onWillPop: null,
          child: Scaffold(
            body: pageInfoList.elementAt(state.selectedIndex).page,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0.1,
              selectedItemColor: ColorStyles.black700,
              unselectedItemColor: ColorStyles.white800,
              selectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
              items: pageInfoList.map<BottomNavigationBarItem>((v) =>
                  BottomNavigationBarItem(
                    icon: Image.asset(v.pageIconPath, height: 26, color: ColorStyles.white800),
                    activeIcon: Image.asset(v.pageIconPath, height: 26, color: ColorStyles.black700),
                    label: v.pageName
                  )
              ).toList(),
              currentIndex: state.selectedIndex, // 지정 인덱스로 이동
              onTap: (idx) {
                context.read<MainTabBloc>().add(MainTabSelectedItem(selectedIndex: idx));
              }, // 선언했던 onItemTapped,
            ),
          )),
    );
  }
}

class _MainTabPageInfo {
  const _MainTabPageInfo({
    required this.page,
    required this.pageIconPath,
    required this.pageName
  });

  final Widget page;
  final String pageIconPath;
  final String pageName;
}