import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';

class FactureDetailsPage extends StatelessWidget {
  final Facture facture;

  const FactureDetailsPage({super.key, required this.facture});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final isPayee = facture.cistatus == 'VALID';
    final isEnRetard = facture.cistatus == 'INPROG' &&
        facture.cidocdate.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la facture'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec statut
            _buildHeaderSection(context, isPayee, isEnRetard),
            const SizedBox(height: 24),
            // Informations principales
            _buildMainInfoSection(context),
            const SizedBox(height: 24),
            // Détails financiers
            _buildFinancialSection(context),
            const SizedBox(height: 32),
            // Action button centered
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isPayee, bool isEnRetard) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'invoice-icon-${facture.ciid}',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withOpacity(0.1),
                          colorScheme.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _getInvoiceIcon(facture.citype),
                      size: 24,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facture.cidocreference,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Référence: ${facture.cireference}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusChip(context, isPayee, isEnRetard),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, bool isPayee, bool isEnRetard) {
    final theme = Theme.of(context);
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isPayee) {
      statusColor = Colors.green;
      statusText = 'Validée';
      statusIcon = Icons.check_circle_rounded;
    } else if (isEnRetard) {
      statusColor = Colors.red;
      statusText = 'Paiement en cours';
      statusIcon = Icons.warning_rounded;
    } else {
      statusColor = Colors.orange;
      statusText = 'En attente';
      statusIcon = Icons.schedule_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 18, color: statusColor),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.description,
              label: 'Type de facture',
              value: facture.citypelabel,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.calendar_today,
              label: 'Date d\'émission',
              value: _formatDate(facture.cidocdate),
            ),
            const SizedBox(height: 12),
            if (facture.clientname != null)
              Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.person,
                    label: 'Client',
                    value: facture.clientname!,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            _buildInfoRow(
              context,
              icon: Icons.assignment,
              label: 'Contrat associé',
              value: facture.ctreference,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPayee = facture.cistatus == 'VALID';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails financiers',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAmountRow(
              context,
              label: 'Montant total',
              amount: facture.cigrosstotal,
              currency: facture.currcode ?? 'EUR',
              isTotal: true,
            ),
            const SizedBox(height: 12),
            _buildAmountRow(
              context,
              label: 'Montant dû',
              amount: facture.cidueamount,
              currency: facture.currcode ?? 'EUR',
              isHighlighted: !isPayee,
            ),
            if (facture.ciidcreditnote != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                icon: Icons.credit_card,
                label: 'Note de crédit associée',
                value: facture.cirefcreditnote ?? 'N/A',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(
      BuildContext context, {
        required String label,
        required double amount,
        required String currency,
        bool isTotal = false,
        bool isHighlighted = false,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? colorScheme.primary.withOpacity(0.08)
            : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? colorScheme.primary.withOpacity(0.2)
              : colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isTotal ? Icons.receipt : Icons.payment,
            size: 20,
            color: isHighlighted
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${amount.toStringAsFixed(2)} $currency',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isHighlighted
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => _downloadFacture(context),
          icon: const Icon(Icons.download_rounded, size: 20),
          label: const Text('Télécharger'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  IconData _getInvoiceIcon(String invoiceType) {
    switch (invoiceType.toUpperCase()) {
      case 'PART':
        return Icons.account_balance_wallet_rounded;
      case 'PREFIN':
        return Icons.trending_up_rounded;
      case 'RENT':
        return Icons.home_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _downloadFacture(BuildContext context) {
    // Implémentation du téléchargement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Téléchargement de la facture...')),
    );
  }
}