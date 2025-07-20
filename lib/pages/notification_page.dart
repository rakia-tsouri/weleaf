import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/notification_model.dart';
import 'package:optorg_mobile/data/repositories/notification_repository.dart';
import 'package:optorg_mobile/widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];
  final NotificationRepository _repo = NotificationRepository();
  List<ApiNotification> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _repo.getNotifications();
      setState(() {
        _notifications = data;
        _isLoading = false;
        _setupAnimations();
      });
      _controller.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _setupAnimations() {
    _slideAnimations.clear();
    _fadeAnimations.clear();

    for (int i = 0; i < _notifications.length; i++) {
      _slideAnimations.add(
        Tween<Offset>(
          begin: Offset(0, -0.5 - (i * 0.1)),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.1 * i, 0.5 + (0.1 * i), curve: Curves.easeOutCubic),
          ),
        ),
      );

      _fadeAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.1 * i, 0.7 + (0.1 * i), curve: Curves.easeIn),
          ),
        ),
      );
    }
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
      if (index < _slideAnimations.length) _slideAnimations.removeAt(index);
      if (index < _fadeAnimations.length) _fadeAnimations.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No notifications'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 13, bottom: 20),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final animationIndex = index < _slideAnimations.length && index < _fadeAnimations.length
              ? index
              : 0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SlideTransition(
              position: _slideAnimations[animationIndex],
              child: FadeTransition(
                opacity: _fadeAnimations[animationIndex],
                child: NotificationCard(
                  notification: _notifications[index],
                  onDismiss: () => _deleteNotification(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}