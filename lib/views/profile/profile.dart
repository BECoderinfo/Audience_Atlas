import 'package:audience_atlas/controllers/profile/profile_controller.dart';
import 'package:audience_atlas/utils/import.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.iconColor,
      ),
      body: Column(
        children: [
          const Gap(40),
          // Banner Section
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              (AppVariables.box.read(StorageKeys.aImage) != null)
                  ? "${Apis.serverAddress}/${AppVariables.box.read(StorageKeys.aImage)}"
                  : (AppVariables.box.read(StorageKeys.aImage) ??
                      'https://avatar.iran.liara.run/public/boy?username=Ash'),
            ),
          ),

          const Gap(50),
          // To account for the profile image overlap

          // Channel Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  AppVariables.box.read(StorageKeys.aName) ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  AppVariables.box.read(StorageKeys.aEmail) ??
                      'User425@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                print('Edit Channel tapped');
                Get.toNamed(Routes.editProfile);
              },
              icon: const Icon(
                Icons.edit,
                color: AppColors.whiteColor,
              ),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.iconColor,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),

          // Channel Description
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     AppVariables.box.read(StorageKeys.aDescription) ??
          //         'Welcome to my channel! Here you will find amazing content about programming, tech, and gaming!',
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(fontSize: 14),
          //   ),
          // ),

          // Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),

          const SizedBox(height: 10),

          // Extra Actions (e.g., Settings, Logout)
          Obx(
            () => ListTile(
              leading: const Icon(Icons.key, color: Colors.grey),
              title: const Text('BioLook'),
              trailing: controller.isBioOn.value
                  ? Text(
                      'On',
                      style: TextStyle(color: AppColors.green),
                    )
                  : Text(
                      'Off',
                      style: TextStyle(color: AppColors.red),
                    ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => BioPopup(
                    onConfirm: () {
                      Get.back();

                      controller.updateBio();
                    },
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.red),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => LogoutPopup(
                  onLogout: () {
                    controller.logout();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Conform logout

class LogoutPopup extends StatelessWidget {
  final VoidCallback? onLogout;

  const LogoutPopup({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          onPressed: onLogout,
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

// Conform bio

class BioPopup extends StatelessWidget {
  final VoidCallback? onConfirm;

  const BioPopup({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bio'),
      content: const Text('Are you sure you want to Start your bioLook?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
