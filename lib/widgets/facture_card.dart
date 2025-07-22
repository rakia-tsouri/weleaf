// widgets/facture_card.dart
import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';

class FactureCard extends StatelessWidget {
  final Facture facture;
  final VoidCallback? onVoirPressed;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onActionPressed;

  const FactureCard({
    super.key,
    required this.facture,
    this.onVoirPressed,
    this.onDownloadPressed,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isPayee = facture.cistatus == 'VALID';
    final isEnRetard = facture.cistatus == 'INPROG' &&
        facture.cidocdate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec référence et statut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                facture.cidocreference,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPayee
                      ? Colors.green.withOpacity(0.1)
                      : isEnRetard
                      ? Colors.red.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPayee
                      ? 'Payée'
                      : isEnRetard
                      ? 'En attente'
                      : '',
                  style: TextStyle(
                    color: isPayee
                        ? Colors.green[700]
                        : isEnRetard
                        ? Colors.orange[700]
                        : Colors.red[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Type de facture
          Text(
            facture.citypelabel,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 20),

          // Montant et contrat
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  label: 'Montant',
                  value: '${facture.cigrosstotal} ${facture.currcode ?? 'EUR'}',
                  isBold: true,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  label: 'Contrat',
                  value: facture.ctreference,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Date d'émission
          _buildInfoItem(
            label: 'Date d\'émission',
            value: _formatDate(facture.cidocdate),
          ),

          const SizedBox(height: 20),

          // Boutons communs (Voir et Télécharger)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onVoirPressed,
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Voir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDownloadPressed,
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Télécharger'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),

          // Bouton d'action spécifique (seulement si non payée)
          if (!isPayee) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: Icon(
                  isEnRetard ? Icons.payment : Icons.schedule,
                  size: 18,
                ),
                label: Text(
                  isEnRetard ? 'Payer maintenant' : 'Programmer le paiement',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnRetard ? Colors.red[600] : Colors.orange[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}