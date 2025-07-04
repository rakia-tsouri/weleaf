import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optorg_mobile/data/models/region.dart';
import 'package:optorg_mobile/services/region_service.dart';

class AttributsForm extends StatefulWidget {
  final VoidCallback? onBack;
  const AttributsForm({Key? key, this.onBack}) : super(key: key);

  @override
  _AttributsFormState createState() => _AttributsFormState();
}

class _AttributsFormState extends State<AttributsForm> {
  // Controllers
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController bicController = TextEditingController();
  final TextEditingController nomBanqueController = TextEditingController();
  final TextEditingController destinataireController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController adresseCompController = TextEditingController();
  final TextEditingController delaisController = TextEditingController();

  // Dropdown values
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

  // Region data
  List<Region> _regions = [];
  bool _isLoadingRegions = false;
  String? _regionError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRegions();
    });
  }

  Future<void> _loadRegions() async {
    if (!mounted) return;

    setState(() {
      _isLoadingRegions = true;
      _regionError = null;
    });

    try {
      final regions = await RegionService.fetchRegions();
      if (!mounted) return;

      setState(() {
        _regions = regions;
        if (regions.isNotEmpty) {
          regionGlobale = regions.first.parvalue;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _regionError = 'Erreur de chargement: ${e.toString()}';
        // Fallback data
        _regions = [
          Region(parvalue: 'ILE', parlistlabel: 'Ile de France', parvalueparent: 'FR'),
          Region(parvalue: 'PACA', parlistlabel: 'Provence Alpes Cote Azur', parvalueparent: 'FR'),
          Region(parvalue: 'CORSE', parlistlabel: 'Corse', parvalueparent: 'FR'),
          Region(parvalue: 'FRBFC', parlistlabel: 'Bourgones', parvalueparent: 'FR'),
        ];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingRegions = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFormSection(
              title: 'Éléments de Financement',
              children: [
                _buildSubsectionTitle('Paiement'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'Mode de Paiement',
                        modePaiement,
                        ['Mode de Paiem...', 'Virement', 'Chèque', 'Espèces'],
                        null,
                            (value) => setState(() => modePaiement = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextFieldWithLabel(
                        'IBAN / RIB',
                        ibanController,
                        'IBAN / RIB',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFieldWithLabel(
                        'BIC',
                        bicController,
                        'BIC',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextFieldWithLabel(
                        'Nom de la Banque',
                        nomBanqueController,
                        'Nom de la Banque',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  'Délai de Paiement',
                  delaiPaiement,
                  ['Délai de Paiement', '30 jours', '60 jours', '90 jours'],
                  null,
                      (value) => setState(() => delaiPaiement = value),
                ),
                const SizedBox(height: 24),
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
                            null,
                                (value) => setState(() => modeFacturation = value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Mode d\'Envoi des Factures',
                            modeEnvoiFactures,
                            ['Mode d\'Envoi des Factur...', 'Email', 'Courrier'],
                            null,
                                (value) => setState(() => modeEnvoiFactures = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldWithLabel(
                      'Destinataire',
                      destinataireController,
                      'Destinataire',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithLabel(
                            'Adresse',
                            adresseController,
                            'Adresse',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextFieldWithLabel(
                            'Adresse Complémentaire',
                            adresseCompController,
                            'Adresse Complémentaire',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Code Postal',
                            codePostal,
                            ['Code Postal', '75001', '69001', '13001'],
                            null,
                                (value) => setState(() => codePostal = value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Ville',
                            ville,
                            ['Ville', 'Paris', 'Lyon', 'Marseille'],
                            null,
                                (value) => setState(() => ville = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      'Région',
                      region,
                      ['Région', 'Île-de-France', 'Auvergne-Rhône-Alpes', 'Provence-Alpes-Côte d\'Azur'],
                      null,
                          (value) => setState(() => region = value),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRegionDropdown(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Pays',
                            pays,
                            ['FR-FRANCE', 'ES-ESPAGNE', 'IT-ITALIE', 'DE-ALLEMAGNE'],
                            null,
                                (value) => setState(() => pays = value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Région Globale',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _isLoadingRegions
              ? const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
              : _regionError != null
              ? Tooltip(
            message: _regionError!,
            child: DropdownButton<String>(
              value: regionGlobale,
              hint: const Text('Erreur de chargement'),
              items: _regions.map((region) {
                return DropdownMenuItem<String>(
                  value: region.parvalue,
                  child: Text(
                    region.parlistlabel,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => regionGlobale = value),
            ),
          )
              : DropdownButton<String>(
            value: regionGlobale,
            hint: const Text('Sélectionnez une région'),
            isExpanded: true,
            items: _regions.map((region) {
              return DropdownMenuItem<String>(
                value: region.parvalue,
                child: Text(
                  region.parlistlabel,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => regionGlobale = value),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String? selectedValue,
      List<String>? options,
      List<Region>? regionOptions,
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
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                options?.first ?? 'Sélectionnez...',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              isExpanded: true,
              items: options?.skip(1).map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
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
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
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