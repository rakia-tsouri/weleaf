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
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_SKY_BLUE_COLOR),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  Text(
                    'Sauvegarde en cours...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        bool success = await _userRepository.updateUserProfile(_user!);

        Navigator.of(context).pop(); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profil sauvegardé avec succès!'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Erreur lors de la sauvegarde'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: _isLoading
              ? _buildLoadingWidget()
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
                          Icons.person_outline,
                          _nameController,
                        ),
                        const SizedBox(height: 20),
                        // Champ User Name
                        _buildTextField(
                          'Nom Utilisateur',
                          Icons.alternate_email,
                          _userNameController,
                        ),
                        const SizedBox(height: 20),
                        // Champ Phone
                        _buildTextField(
                          'Téléphone',
                          Icons.phone_outlined,
                          _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        // Champ Mobile
                        _buildTextField(
                          'Mobile',
                          Icons.phone_iphone_outlined,
                          _mobileController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 40),
                        // Bouton Save sous les champs
                        SizedBox(
                          width: isSmallScreen ? double.infinity : 200,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_SKY_BLUE_COLOR,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              shadowColor: PRIMARY_SKY_BLUE_COLOR.withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save, size: 20),
                                const SizedBox(width: 8),
                                const Text('Sauvegarder'),
                              ],
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

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_SKY_BLUE_COLOR),
              backgroundColor: PRIMARY_SKY_BLUE_COLOR.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Chargement du profil...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Oups !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadUserProfile,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_SKY_BLUE_COLOR,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                iconSize: 24,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Mon Compte',
              style: TextStyle(
                fontSize: isSmallScreen ? 22 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            Container(
              width: isSmallScreen ? 100 : 120,
              height: isSmallScreen ? 100 : 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PRIMARY_SKY_BLUE_COLOR,
                    PRIMARY_SKY_BLUE_COLOR.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: PRIMARY_SKY_BLUE_COLOR.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                size: isSmallScreen ? 50 : 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _user?.data?.surname ?? appName,
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _user?.data?.email ?? 'Email non disponible',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label,
      IconData icon,
      TextEditingController controller, {
        String? hintText,
        TextInputType? keyboardType,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: false,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: PRIMARY_SKY_BLUE_COLOR,
            size: 22,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: PRIMARY_SKY_BLUE_COLOR,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return Empty_Input_Error;
          }
          return null;
        },
      ),
    );
  }
}