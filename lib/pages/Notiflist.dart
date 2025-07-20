import 'package:flutter/material.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modèle de données pour la réponse API
class ApiNotification {
  final int id;
  final int notifid;
  final String notifmessage;
  final String? sendername;
  final String? conseqstatusdate;
  final String? modulename;
  final String? objectreference;
  final String? receiverroleprofilelabel;

  ApiNotification({
    required this.id,
    required this.notifid,
    required this.notifmessage,
    this.sendername,
    this.conseqstatusdate,
    this.modulename,
    this.objectreference,
    this.receiverroleprofilelabel,
  });

  factory ApiNotification.fromJson(Map<String, dynamic> json) {
    return ApiNotification(
      id: json['id'] ?? 0,
      notifid: json['notifid'] ?? 0,
      notifmessage: json['notifmessage'] ?? '',
      sendername: json['sendername'],
      conseqstatusdate: json['conseqstatusdate'],
      modulename: json['modulename'],
      objectreference: json['objectreference'],
      receiverroleprofilelabel: json['receiverroleprofilelabel'],
    );
  }

  // Convertir en NotificationItem pour l'affichage
  NotificationItem toNotificationItem() {
    return NotificationItem(
      id: id.toString(),
      title: notifmessage,
      type: modulename ?? 'General',
      user: sendername ?? 'Unknown',
      time: _formatDate(conseqstatusdate),
      reference: objectreference,
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation<Offset>> _animations = [];
  List<Animation<double>> _opacityAnimations = [];

  // Variables pour l'API
  List<NotificationItem> notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  final AppDataStore _appDataStore = AppDataStore();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _loadNotifications();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fonction pour charger les notifications depuis l'API
  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Récupérer le token
      final token = await _appDataStore.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant');
      }

      print('🔐 Chargement des notifications avec token: ${token.substring(0, 20)}...');

      // Appel API
      final response = await http.get(
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/workflow-service/api/myNotiflist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Réponse API notifications: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('📊 Données reçues: ${data['code']} - ${data['message']}');

        if (data['code'] == '200' && data['list'] != null) {
          final List<dynamic> notificationsList = data['list'];

          // Convertir les données API en NotificationItem
          final apiNotifications = notificationsList
              .map((json) => ApiNotification.fromJson(json))
              .toList();

          final convertedNotifications = apiNotifications
              .map((apiNotif) => apiNotif.toNotificationItem())
              .toList();

          setState(() {
            notifications = convertedNotifications;
            _isLoading = false;
          });

          // Créer les animations pour les nouvelles notifications
          _createAnimations();
          _controller.forward();

          print('✅ ${notifications.length} notifications chargées');
        } else {
          throw Exception('Format de réponse invalide');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Token d\'authentification invalide ou expiré');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur chargement notifications: $e');
      setState(() {
        _errorMessage = 'Erreur de chargement: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Créer les animations pour les notifications
  void _createAnimations() {
    _animations.clear();
    _opacityAnimations.clear();

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
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      if (index < _animations.length) {
        _animations.removeAt(index);
      }
      if (index < _opacityAnimations.length) {
        _opacityAnimations.removeAt(index);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification supprimée'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNotifications,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Chargement des notifications...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadNotifications,
              icon: Icon(Icons.refresh),
              label: Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return _buildNotificationList();
  }

  Widget _buildNotificationList() {
    return notifications.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Vos notifications apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    )
        : RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 13, bottom: 20),
        physics: BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return index < _animations.length && index < _opacityAnimations.length
              ? FadeTransition(
            opacity: _opacityAnimations[index],
            child: SlideTransition(
              position: _animations[index],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildNotificationCard(notification, index),
              ),
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildNotificationCard(notification, index),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return Dismissible(
      key: Key('${notification.id}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 6),
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
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
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
              if (notification.reference != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ref: ${notification.reference}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: Colors.grey[700],
                  ),
                  SizedBox(width: 6),
                  Text(
                    notification.user,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
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
      case 'proposal':
        return Color(0xFFDA128A);
      case 'contract':
        return Color(0xFFE65100);
      default:
        return Color(0xFF6A1B9A);
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String type;
  final String user;
  final String time;
  final String? reference;

  NotificationItem({
    required this.id,
    required this.title,
    required this.type,
    required this.user,
    required this.time,
    this.reference,
  });
}