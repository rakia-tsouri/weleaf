import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/data/repositories/user_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();

  // Controllers pour les champs de texte
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();

  // Variables pour gérer l'état
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  /// Load user profile using repository
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _user = await _userRepository.getCurrentUserProfile();

      if (_user?.data != null) {
        // Populate form controllers with user data
        _nameController.text = _user!.data!.name ?? '';
        _userNameController.text = _user!.data!.username ?? '';
        _phoneController.text = _user!.data!.phone ?? '';
        _mobileController.text = _user!.data!.mobile ?? '';

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Impossible de charger le profil utilisateur';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().contains('Token')
            ? 'Token d\'authentification invalide. Veuillez vous reconnecter.'
            : 'Erreur de connexion: $e';
      });
    }
  }

  /// Save profile using repository
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_user?.data != null) {
      // Update user data with form values
      _user!.data!.name = _nameController.text;
      _user!.data!.username = _userNameController.text;
      _user!.data!.phone = _phoneController.text;
      _user!.data!.mobile = _mobileController.text;

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        bool success = await _userRepository.updateUserProfile(_user!);

        Navigator.of(context).pop(); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil sauvegardé avec succès!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la sauvegarde'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
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
            onPressed: _loadUserProfile,
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
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                iconSize: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Compte',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
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
              Text(
                _user?.data?.surname ?? appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _user?.data?.email ?? 'Email non disponible',
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
                  const Text(
                    'Compte',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  Text(
                    _user?.data?.surname ?? appName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user?.data?.email ?? 'Email non disponible',
                    style: TextStyle(
                      fontSize: 18,
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
          readOnly: false, // Made editable for profile updates
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
}