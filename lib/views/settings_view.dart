import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/settings_controller.dart';
import 'package:todo_app/widgets/base_layout.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(SettingsController());

    return BaseLayout(
      currentIndex: 3,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  theme,
                  'Appearance',
                  [
                    _buildSettingTile(
                      theme,
                      'Dark Mode',
                      'Enable dark theme',
                      Icons.dark_mode,
                      trailing: Obx(() => Switch(
                            value: controller.isDarkMode.value,
                            onChanged: controller.toggleDarkMode,
                          )),
                    ),
                    _buildSettingTile(
                      theme,
                      'Accent Color',
                      'Choose app accent color',
                      Icons.palette,
                      onTap: () => _showColorPicker(context, controller),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  theme,
                  'Notifications',
                  [
                    _buildSettingTile(
                      theme,
                      'Push Notifications',
                      'Enable push notifications',
                      Icons.notifications,
                      trailing: Obx(() => Switch(
                            value: controller.pushNotifications.value,
                            onChanged: controller.togglePushNotifications,
                          )),
                    ),
                    _buildSettingTile(
                      theme,
                      'Email Notifications',
                      'Enable email notifications',
                      Icons.email,
                      trailing: Obx(() => Switch(
                            value: controller.emailNotifications.value,
                            onChanged: controller.toggleEmailNotifications,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  theme,
                  'Data',
                  [
                    _buildSettingTile(
                      theme,
                      'Clear All Data',
                      'Reset app to default settings',
                      Icons.delete_forever,
                      onTap: () => _showClearDataDialog(context, controller),
                    ),
                    _buildSettingTile(
                      theme,
                      'Export Data',
                      'Export your data as JSON',
                      Icons.upload_file,
                      onTap: controller.exportData,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  theme,
                  'About',
                  [
                    _buildSettingTile(
                      theme,
                      'Version',
                      '1.0.0',
                      Icons.info,
                    ),
                    _buildSettingTile(
                      theme,
                      'Privacy Policy',
                      'View privacy policy',
                      Icons.privacy_tip,
                      onTap: () => Get.toNamed('/privacy'),
                    ),
                    _buildSettingTile(
                      theme,
                      'Terms of Service',
                      'View terms of service',
                      Icons.description,
                      onTap: () => Get.toNamed('/terms'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, SettingsController controller) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Accent Color',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildColorOption(Colors.blue, controller),
                _buildColorOption(Colors.purple, controller),
                _buildColorOption(Colors.pink, controller),
                _buildColorOption(Colors.red, controller),
                _buildColorOption(Colors.orange, controller),
                _buildColorOption(Colors.amber, controller),
                _buildColorOption(Colors.yellow, controller),
                _buildColorOption(Colors.lightGreen, controller),
                _buildColorOption(Colors.green, controller),
                _buildColorOption(Colors.teal, controller),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(MaterialColor color, SettingsController controller) {
    return Obx(() {
      final isSelected = controller.accentColor.value == color;
      return GestureDetector(
        onTap: () => controller.setAccentColor(color),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 3,
            ),
          ),
        ),
      );
    });
  }

  void _showClearDataDialog(
      BuildContext context, SettingsController controller) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to clear all data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              controller.clearAllData();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
