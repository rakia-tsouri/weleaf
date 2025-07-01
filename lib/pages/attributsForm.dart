import 'package:flutter/material.dart';

class AttributsForm extends StatefulWidget {
  final VoidCallback? onBack;

  const AttributsForm({Key? key, this.onBack}) : super(key: key);

  @override
  _AttributsFormState createState() => _AttributsFormState();
}

class _AttributsFormState extends State<AttributsForm> {
  // Controllers pour les champs de texte
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController bicController = TextEditingController();
  final TextEditingController nomBanqueController = TextEditingController();
  final TextEditingController destinataireController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController adresseCompController = TextEditingController();
  final TextEditingController delaisController = TextEditingController();

  // Variables pour les dropdowns
  String? modePaiement;
  String? delaiPaiement;
  String? interetsRetard;
  String? remboursementTotal;
  String? remboursementPartiel;
  String? fraisModification;
  String? fraisDegradation;
  String? fraisDepassement;
  String? modeFacturation;
  String? modeEnvoiFactures;
  String? codePostal;
  String? ville;
  String? region;
  String? regionGlobale;
  String? pays;
  String? conditionsSpecifiques;
  String? statut;
  String? tache;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Éléments de Financement Section
            _buildFormSection(
              title: 'Éléments de Financement',
              children: [
                // Paiement Subsection
                _buildSubsectionTitle('Paiement'),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'Mode de Paiement',
                        modePaiement,
                        ['Mode de Paiem...', 'Virement', 'Chèque', 'Espèces'],
                        (value) => setState(() => modePaiement = value),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTextFieldWithLabel(
                        'IBAN / RIB',
                        ibanController,
                        'IBAN / RIB',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFieldWithLabel(
                        'BIC',
                        bicController,
                        'BIC',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTextFieldWithLabel(
                        'Nom de la Banque',
                        nomBanqueController,
                        'Nom de la Banque',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDropdownField(
                  'Délai de Paiement',
                  delaiPaiement,
                  ['Délai de Paiement', '30 jours', '60 jours', '90 jours'],
                  (value) => setState(() => delaiPaiement = value),
                ),

                SizedBox(height: 24),

                // Adresse de Facturation Section
                _buildFormSection(
                  title: 'Adresse de Facturation',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Mode de Facturation',
                            modeFacturation,
                            ['Mode de Facturation', 'Électronique', 'Papier'],
                            (value) => setState(() => modeFacturation = value),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Mode d\'Envoi des Factures',
                            modeEnvoiFactures,
                            [
                              'Mode d\'Envoi des Factur...',
                              'Email',
                              'Courrier',
                            ],
                            (value) =>
                                setState(() => modeEnvoiFactures = value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldWithLabel(
                      'Destinataire',
                      destinataireController,
                      'Destinataire',
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithLabel(
                            'Adresse',
                            adresseController,
                            'Adresse',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildTextFieldWithLabel(
                            'Adresse Complémentaire',
                            adresseCompController,
                            'Adresse Complémentaire',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Code Postal',
                            codePostal,
                            ['Code Postal', '75001', '69001', '13001'],
                            (value) => setState(() => codePostal = value),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField('Ville', ville, [
                            'Ville',
                            'Paris',
                            'Lyon',
                            'Marseille',
                          ], (value) => setState(() => ville = value)),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildDropdownField('Région', region, [
                      'Région',
                      'Île-de-France',
                      'Auvergne-Rhône-Alpes',
                      'Provence-Alpes-Côte d\'Azur',
                    ], (value) => setState(() => region = value)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Région Globale',
                            regionGlobale,
                            ['Région Globale', 'Europe', 'Amérique', 'Asie'],
                            (value) => setState(() => regionGlobale = value),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField('Pays', pays, [
                            'FR-FRANCE',
                            'ES-ESPAGNE',
                            'IT-ITALIE',
                            'DE-ALLEMAGNE',
                          ], (value) => setState(() => pays = value)),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                options.first,
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 20,
              ),
              isExpanded: true,
              items:
                  options.skip(1).map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel(
    String label,
    TextEditingController controller,
    String placeholder,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}