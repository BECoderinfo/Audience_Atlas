import 'package:atlas_admin/controllers/dash/dashboard_controller.dart';
import 'package:atlas_admin/utils/import.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GridItemTile(
                    title: 'Total \nVideos',
                    value: '5',
                    color: AppColors.iconColor,
                  ),
                ),
                Gap(16),
                Expanded(
                  child: GridItemTile(
                    title: 'Total \nUsers',
                    value: '20',
                    color: AppColors.iconColor,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: GridItemTile(
                    title: 'Total \nPublishers',
                    value: '2',
                    color: AppColors.iconColor,
                  ),
                ),
                Gap(16),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            DrawerItem(
              title: 'Dashboard',
              icon: Icons.dashboard_outlined,
              onTap: () {
                Get.back();
              },
            ),
            DrawerItem(
              title: 'Manage Publishers',
              icon: Icons.supervised_user_circle,
              onTap: () {
                Get.toNamed(Routes.publishers);
              },
            ),
            DrawerItem(
              title: 'Profile',
              icon: Icons.person_outline_sharp,
              onTap: () {
                Get.toNamed(Routes.profile);
              },
            ),
            DrawerItem(
              title: 'Logout',
              iconColor: AppColors.red,
              titleColor: AppColors.red,
              icon: Icons.logout,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.title,
    this.titleColor = Colors.black,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: titleColor)),
      onTap: onTap,
    );
  }
}

class GridItemTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const GridItemTile({
    super.key,
    required this.title,
    required this.value,
    this.color = AppColors.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const Gap(10),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
