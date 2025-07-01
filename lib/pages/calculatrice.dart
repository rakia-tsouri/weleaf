import 'package:flutter/material.dart';

class CalculatricePage extends StatefulWidget {
  @override
  _CalculatricePageState createState() => _CalculatricePageState();
}

class _CalculatricePageState extends State<CalculatricePage> {
  // Controllers pour les champs de texte
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _dureeController = TextEditingController();
  final TextEditingController _premierLoyerController = TextEditingController();
  final TextEditingController _valeurResiduellController =
  TextEditingController();
  final TextEditingController _periodeGraceController = TextEditingController();
  final TextEditingController _loyerController = TextEditingController();

  // Valeurs des sliders
  double _montantFinance = 50;
  double _duree = 24;
  double _premierLoyer = 0;
  double _valeurResiduelle = 0;
  double _periodeGrace = 0;

  @override
  void initState() {
    super.initState();

    // Listeners pour synchroniser les champs de texte avec les sliders
    _montantController.addListener(() {
      final value = double.tryParse(_montantController.text);
      if (value != null && value >= 50 && value <= 1200000) {
        setState(() {
          _montantFinance = value;
        });
      }
    });

    _dureeController.addListener(() {
      final value = double.tryParse(_dureeController.text);
      if (value != null && value >= 24 && value <= 60) {
        setState(() {
          _duree = value;
        });
      }
    });

    _premierLoyerController.addListener(() {
      final value = double.tryParse(_premierLoyerController.text);
      if (value != null && value >= 0 && value <= 30) {
        setState(() {
          _premierLoyer = value;
        });
      }
    });

    _valeurResiduellController.addListener(() {
      final value = double.tryParse(_valeurResiduellController.text);
      if (value != null && value >= 0 && value <= 20) {
        setState(() {
          _valeurResiduelle = value;
        });
      }
    });

    _periodeGraceController.addListener(() {
      final value = double.tryParse(_periodeGraceController.text);
      if (value != null && value >= 0 && value <= 3) {
        setState(() {
          _periodeGrace = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la largeur de l'écran pour des dimensions responsives
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.3; // 60% de la largeur d'écran
    double fieldWidth = screenWidth * 0.5; // 75% de la largeur d'écran

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF2563EB),
        title: Text('Calculatrice', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre SIMULATEUR
            Text(
              'SIMULATEUR',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 20),

            // Montant financé
            _buildSliderField(
              label: 'Montant financé :',
              value: _montantFinance,
              min: 50,
              max: 1200000,
              controller: _montantController,
              suffix: '',
              onChanged: (value) {
                setState(() {
                  _montantFinance = value;
                  _montantController.text = value.round().toString();
                });
              },
            ),

            SizedBox(height: 20),

            // Durée
            _buildSliderField(
              label: 'Durée :',
              value: _duree,
              min: 24,
              max: 60,
              controller: _dureeController,
              suffix: 'mois',
              onChanged: (value) {
                setState(() {
                  _duree = value;
                  _dureeController.text = value.round().toString();
                });
              },
            ),

            SizedBox(height: 20),

            // Premier loyer
            _buildSliderField(
              label: 'Premier loyer :',
              value: _premierLoyer,
              min: 0,
              max: 30,
              controller: _premierLoyerController,
              suffix: '%',
              onChanged: (value) {
                setState(() {
                  _premierLoyer = value;
                  _premierLoyerController.text = value.round().toString();
                });
              },
            ),

            SizedBox(height: 20),

            // Valeur résiduelle
            _buildSliderField(
              label: 'Valeur résiduelle :',
              value: _valeurResiduelle,
              min: 0,
              max: 20,
              controller: _valeurResiduellController,
              suffix: '%',
              onChanged: (value) {
                setState(() {
                  _valeurResiduelle = value;
                  _valeurResiduellController.text = value.round().toString();
                });
              },
            ),

            SizedBox(height: 20),

            // Période de grâce
            _buildSliderField(
              label: 'Période de grâce :',
              value: _periodeGrace,
              min: 0,
              max: 3,
              controller: _periodeGraceController,
              suffix: 'mois',
              onChanged: (value) {
                setState(() {
                  _periodeGrace = value;
                  _periodeGraceController.text = value.round().toString();
                });
              },
            ),

            SizedBox(height: 40),

            // Bouton Calculer - Centré avec largeur réduite
            Center(
              child: SizedBox(
                width: buttonWidth,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    _calculer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Calculer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Champ de résultat Loyer - Centré avec largeur légèrement plus grande
            Center(
              child: SizedBox(
                width: fieldWidth,
                child: TextField(
                  controller: _loyerController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required TextEditingController controller,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label au-dessus
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 8),

        // Ligne avec valeur min, slider, valeur max et champ de texte
        Row(
          children: [
            // Valeur minimum
            SizedBox(
              width: 50,
              child: Text(
                _formatValue(min, suffix),
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
              ),
            ),

            // Slider
            Expanded(
              flex: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF2563EB),
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Color(0xFF2563EB),
                  overlayColor: Color(0xFF2563EB).withOpacity(0.2),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),

            // Valeur maximum
            SizedBox(
              width: 50,
              child: Text(
                _formatValue(max, suffix),
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                textAlign: TextAlign.right,
              ),
            ),

            SizedBox(width: 8),

            // Champ de texte à droite
            Container(
              width: 85,
              height: 32,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  suffix: Text(suffix, style: TextStyle(fontSize: 11)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Color(0xFF2563EB)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatValue(double value, String suffix) {
    if (suffix == '') {
      // Pour le montant, formater avec des espaces
      if (value >= 1000) {
        return '${(value / 1000).round()} k';
      }
      return value.round().toString();
    }
    return '${value.round()} $suffix';
  }

  void _calculer() {
    // Vérifier que tous les champs sont remplis
    if (_montantController.text.isEmpty ||
        _dureeController.text.isEmpty ||
        _premierLoyerController.text.isEmpty ||
        _valeurResiduellController.text.isEmpty ||
        _periodeGraceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Logique de calcul simple (à adapter selon vos besoins)
    double montant = double.parse(_montantController.text);
    double duree = double.parse(_dureeController.text);
    double premierLoyer = double.parse(_premierLoyerController.text);
    double valeurResiduelle = double.parse(_valeurResiduellController.text);

    // Calcul simplifié du loyer mensuel
    double montantFinance = montant * (1 - premierLoyer / 100);
    double valeurResiduelleMontant = montant * (valeurResiduelle / 100);
    double montantAFinancer = montantFinance - valeurResiduelleMontant;
    double loyerMensuel = montantAFinancer / duree;

    // Afficher le résultat dans le champ loyer
    setState(() {
      _loyerController.text =
      '${loyerMensuel.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} €';
    });
  }

  @override
  void dispose() {
    _montantController.dispose();
    _dureeController.dispose();
    _premierLoyerController.dispose();
    _valeurResiduellController.dispose();
    _periodeGraceController.dispose();
    _loyerController.dispose();
    super.dispose();
  }
}