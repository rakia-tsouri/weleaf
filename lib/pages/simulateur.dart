import 'package:flutter/material.dart';

class SimulateurForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildProduitSection()),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildStatutSection()),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    _buildProduitSection(),
                    SizedBox(height: 16),
                    _buildStatutSection(),
                  ],
                );
              }
            },
          ),

          SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commentaires',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Commentaires',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProduitSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Produit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          _buildFormField('Réf', isTextField: true),
          SizedBox(height: 12),

          _buildFormField(
            'Produit',
            items: ['ceci est un test de démo', 'Autre'],
            hint: 'ceci est un test de démo',
          ),
          SizedBox(height: 12),

          _buildFormField(
            'Type de Montage',
            items: ['Élément financier unique', 'Autre'],
            hint: 'Élément financier unique',
          ),
          SizedBox(height: 12),

          _buildFormField('Devise', items: ['EUR'], hint: 'Devise'),
          SizedBox(height: 12),

          _buildFormField(
            'Montant financé',
            isTextField: true,
            hint: 'MAD 0.00',
          ),
          SizedBox(height: 12),

          _buildFormField(
            'Type de Contrat',
            items: ['Seule', 'Autre'],
            hint: 'Seule',
          ),

          SizedBox(height: 16),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStatutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Statut',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          _buildFormField('Statut', isTextField: true),

          SizedBox(height: 12),

          _buildFormField(
            'Date de la Demande',
            isTextField: true,
            hint: '2025-06-22',
            isDate: true,
          ),

          SizedBox(height: 12),

          _buildFormField(
            'Date Début Initiale',
            isTextField: true,
            hint: '2025-06-22',
            isDate: true,
          ),

          SizedBox(height: 12),

          _buildFormField('Durée', isTextField: true, hint: 'Durée'),

          SizedBox(height: 16),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Dates',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                _buildDateField('Date Initiale'),
                SizedBox(height: 12),
                _buildDateField('Date de Validité'),
                SizedBox(height: 12),
                _buildDateField('Date de Fin'),
                SizedBox(height: 12),
                _buildDateField('Date de décision'),
                SizedBox(height: 12),
                _buildDateField('Date de signature'),
                SizedBox(height: 12),
                _buildDateField('Date d\'Activation'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label, {
    bool isTextField = false,
    List<String>? items,
    String? hint,
    bool isDate = false,
    bool hasSearchIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        if (isTextField)
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: hint,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon:
                  isDate
                      ? Icon(Icons.calendar_today, size: 16)
                      : hasSearchIcon
                      ? Icon(Icons.search, size: 16)
                      : null,
            ),
          )
        else
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            hint: Text(hint ?? label, overflow: TextOverflow.ellipsis),
            items:
                items?.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
            onChanged: (value) {},
          ),
      ],
    );
  }

  Widget _buildDateField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            suffixIcon: Icon(Icons.calendar_today, size: 14),
          ),
        ),
      ],
    );
  }
}