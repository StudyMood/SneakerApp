import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  final bool showBackButton;

  const NotificationsScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifProvider = context.watch<NotificationProvider>();
    final notifications = notifProvider.notifications;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
              ),
              onSelected: (val) {
                if (val == 'read_all') {
                  notifProvider.markAllAsRead();
                } else if (val == 'clear_all') {
                  notifProvider.clearAll();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'read_all',
                  child: Row(
                    children: [
                      Icon(Icons.done_all_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_rounded, size: 18, color: AppColors.accent),
                      SizedBox(width: 8),
                      Text('Clear all', style: TextStyle(color: AppColors.accent)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFF4F5F7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_off_outlined,
                      size: 44,
                      color: isDark ? Colors.white38 : const Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Notifications Yet',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You will receive live updates on orders,\nprice drops and new sneaker drops!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF8E8E93),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return InkWell(
                  onTap: () {
                    notifProvider.markAsRead(notif.id);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: !notif.isRead
                            ? AppColors.flipkartBlue.withOpacity(0.4)
                            : (isDark ? AppColors.borderDark : const Color(0xFFEEEEEE)),
                        width: !notif.isRead ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Box
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: notif.iconColor.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            notif.icon,
                            size: 22,
                            color: notif.iconColor,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Text details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                  if (!notif.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.flipkartBlue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.message,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF767676),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif.timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
