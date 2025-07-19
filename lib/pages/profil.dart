import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optorg_mobile/utils/app_data_store.dart'; // Importer AppDataStore
import 'package:optorg_mobile/data/repositories/auth_repository.dart';

// Modèle de données pour la réponse API
class UserProfile {
  final String username;
  final String name;
  final String surname;
  final String email;
  final String lancode;
  final String userrole;
  final int mgid;
  final String status;
  final bool locked;
  final String phone;
  final String mobile;
  final bool changepassword;
  final String route;
  final String usertype;
  final String tabposition;

  UserProfile({
    required this.username,
    required this.name,
    required this.surname,
    required this.email,
    required this.lancode,
    required this.userrole,
    required this.mgid,
    required this.status,
    required this.locked,
    required this.phone,
    required this.mobile,
    required this.changepassword,
    required this.route,
    required this.usertype,
    required this.tabposition,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      lancode: json['lancode'] ?? '',
      userrole: json['userrole'] ?? '',
      mgid: json['mgid'] ?? 0,
      status: json['status'] ?? '',
      locked: json['locked'] ?? false,
      phone: json['phone'] ?? '',
      mobile: json['mobile'] ?? '',
      changepassword: json['changepassword'] ?? false,
      route: json['route'] ?? '',
      usertype: json['usertype'] ?? '',
      tabposition: json['tabposition'] ?? '',
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour les champs de texte
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();

  // Variables pour gérer l'état
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // Fonction pour initialiser le token et charger le profil
  Future<void> _initializeAndLoadProfile() async {
    await _getAuthToken();
    await _loadUserProfile();
  }

  // Fonction pour récupérer le token depuis AppDataStore
  Future<void> _getAuthToken() async {
    try {
      print('🔍 Début de la récupération du token depuis AppDataStore...');

      final appStorage = AppDataStore();
      _authToken = await appStorage.getToken(); // Utiliser AppDataStore

      if (_authToken != null && _authToken!.isNotEmpty) {
        print('✅ Token récupéré depuis AppDataStore: ${_authToken!.substring(0, 20)}...');
      } else {
        print('❌ Aucun token trouvé dans AppDataStore');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du token: $e');
    }
  }

  // Fonction pour appeler l'API avec le token
  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('🌐 Début de l\'appel API...');

      // Vérifier si on a un token
      if (_authToken == null || _authToken!.isEmpty) {
        print('❌ Token manquant ou vide');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Token d\'authentification manquant. Veuillez vous reconnecter.';
        });
        return;
      }

      print('🔐 Utilisation du token: ${_authToken!.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/authentication-service/authenticate/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      print('📡 Réponse API: ${response.statusCode}');
      print('📄 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Succès de l\'API');
        final Map<String, dynamic> data = json.decode(response.body);
        print('📊 Données reçues: $data');

        _userProfile = UserProfile.fromJson(data);

        // Mettre à jour les controllers avec les données de l'API
        _nameController.text = _userProfile!.name;
        _userNameController.text = _userProfile!.username;
        _phoneController.text = _userProfile!.phone;
        _mobileController.text = _userProfile!.mobile;

        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        print('❌ Erreur 401: Token invalide ou expiré');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Token d\'authentification invalide ou expiré. Veuillez vous reconnecter.';
        });
      } else {
        print('❌ Erreur ${response.statusCode}: ${response.body}');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur lors du chargement du profil: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('❌ Exception lors de l\'appel API: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur de connexion: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? _buildErrorWidget()
              : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec boutons
                _buildHeader(isSmallScreen),

                SizedBox(height: isSmallScreen ? 24 : 40),

                // Formulaire
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Champ Name
                        _buildTextField(
                          'Nom Complet',
                          _nameController,
                        ),

                        const SizedBox(height: 20),

                        // Champ User Name
                        _buildTextField(
                          'Nom Utilisateur',
                          _userNameController,
                        ),

                        const SizedBox(height: 20),

                        // Champ Phone
                        _buildTextField(
                          'Téléphone',
                          _phoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 20),

                        // Champ Mobile
                        _buildTextField(
                          'Mobile',
                          _mobileController,
                          hintText: 'Mobile',
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 40),

                        // Bouton Save sous les champs
                        SizedBox(
                          width: 200,
                          child: ElevatedButton.icon(
                            onPressed: _saveProfile,
                            icon: const Icon(Icons.save, size: 18),
                            label: const Text('Sauvegarder'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_SKY_BLUE_COLOR,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 18),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initializeAndLoadProfile,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_SKY_BLUE_COLOR,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    if (isSmallScreen) {
      // Layout mobile : tout en vertical
      return Column(
        children: [
          // Bouton retour en haut à gauche
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                iconSize: 24,
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 20),

          // Avatar et infos
          Column(
            children: [
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: PRIMARY_SKY_BLUE_COLOR,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Nom principal (utilise surname de l'API)
              Text(
                _userProfile?.surname ?? appName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Email (utilise email de l'API)
              Text(
                _userProfile?.email ?? 'Email non disponible',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
    } else {
      // Layout desktop : horizontal
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            iconSize: 24,
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: PRIMARY_SKY_BLUE_COLOR,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nom principal (utilise surname de l'API)
                  Text(
                    _userProfile?.surname ?? appName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email (utilise email de l'API)
                  Text(
                    _userProfile?.email ?? 'Email non disponible',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      );
    }
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        String? hintText,
        TextInputType? keyboardType,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFF3F51B5)),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return Empty_Input_Error;
            }
            return null;
          },
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Logique de sauvegarde
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil sauvegardé avec succès!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
