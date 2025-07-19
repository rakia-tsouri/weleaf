import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations = [];
  late List<Animation<double>> _opacityAnimations = [];

  final List<NotificationItem> notifications = [
    NotificationItem(
      id: '0000003586',
      title: 'Print document EQDOM',
      type: 'Propositions',
      user: 'ADMIN ADMIN',
      time: '10:30 AM',
    ),
    NotificationItem(
      id: '0000003587',
      title: 'Review quarterly report',
      type: 'Finance',
      user: 'MANAGER',
      time: '11:45 AM',
    ),
    NotificationItem(
      id: '0000003588',
      title: 'Approve budget proposal',
      type: 'Operations',
      user: 'DIRECTOR',
      time: 'Yesterday',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Création des animations pour chaque notification
    for (int i = 0; i < notifications.length; i++) {
      final positionAnimation = Tween<Offset>(
        begin: Offset(0, -0.5 - (i * 0.1)),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * i,
            0.5 + (0.1 * i),
            curve: Curves.easeOutCubic,
          ),
        ),
      );

      final opacityAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * i,
            0.7 + (0.1 * i),
            curve: Curves.easeIn,
          ),
        ),
      );

      _animations.add(positionAnimation);
      _opacityAnimations.add(opacityAnimation);
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      _animations.removeAt(index);
      _opacityAnimations.removeAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification deleted'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    return notifications.isEmpty
        ? Center(
      child: Text(
        'No notifications',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[700], // Gris plus foncé
          fontWeight: FontWeight.w500,
        ),
      ),
    )
        : ListView.builder(
      padding: EdgeInsets.only(top: 16, bottom: 24),
      physics: BouncingScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return FadeTransition(
          opacity: _opacityAnimations[index],
          child: SlideTransition(
            position: _animations[index],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildNotificationCard(notification, index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return Dismissible(
      key: Key('${notification.id}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 8),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (direction) => _deleteNotification(index),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      notification.type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(notification.type),
                      ),
                    ),
                  ),
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800], // Gris plus foncé pour l'heure
                      fontWeight: FontWeight.w500, // Plus visible
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: Colors.grey[700], // Gris plus foncé pour l'icône
                  ),
                  SizedBox(width: 6),
                  Text(
                    notification.user,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800], // Gris plus foncé pour le nom
                      fontWeight: FontWeight.w500, // Plus visible
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'propositions':
        return Color(0xFF6A1B9A);
      case 'finance':
        return Color(0xFF2E7D32);
      case 'operations':
        return Color(0xFF1565C0);
      default:
        return Color(0xFFDA128A);
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String type;
  final String user;
  final String time;

  NotificationItem({
    required this.id,
    required this.title,
    required this.type,
    required this.user,
    required this.time,
  });
}