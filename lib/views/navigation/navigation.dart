import 'package:animations/animations.dart';
import 'package:audience_atlas/controllers/navigation/navigation_controller.dart';
import 'package:audience_atlas/utils/import.dart';
import 'package:audience_atlas/views/home/home.dart';
import 'package:audience_atlas/views/profile/profile.dart';
import 'package:audience_atlas/views/publishers/publishers.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller = Get.put(NavigationController());

    final List<Widget> pages = <Widget>[
      Home(),
      Publishers(),
      ProfilePage(),
    ];

    return Scaffold(
      body: Obx(
        () {
          return PageTransitionSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: pages[controller.pageNo.value],
          );
        },
      ),
      bottomNavigationBar: Obx(
        () {
          return StylishBottomBar(
            currentIndex: controller.pageNo.value,
            onTap: (index) {
              controller.changePage(index); // Change selected index
            },
            items: [
              BottomBarItem(
                icon: const Icon(
                  Icons.house_outlined,
                ),
                selectedIcon: const Icon(Icons.house_rounded),
                selectedColor: AppColors.iconColor,
                unSelectedColor: AppColors.greyColor,
                title: const Text('Home'),
              ),
              BottomBarItem(
                icon: const Icon(
                  Icons.group_outlined,
                ),
                selectedIcon: const Icon(
                  Icons.group,
                ),
                selectedColor: AppColors.iconColor,
                unSelectedColor: AppColors.greyColor,
                title: const Text('Publishers'),
              ),
              BottomBarItem(
                icon: const Icon(
                  Icons.person_outline,
                ),
                selectedIcon: const Icon(
                  Icons.person,
                ),
                selectedColor: AppColors.iconColor,
                unSelectedColor: AppColors.greyColor,
                title: const Text('Profile'),
              ),
            ],
            option: DotBarOptions(
              dotStyle: DotStyle.tile,
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.iconColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          );
        },
      ),
    );
  }
}
