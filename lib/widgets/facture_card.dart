import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/pages/FactureDetailsPage.dart';

class FactureCard extends StatefulWidget {
  final Facture facture;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onActionPressed;

  const FactureCard({
    super.key,
    required this.facture,
    this.onDownloadPressed,
    this.onActionPressed,
  });

  @override
  State<FactureCard> createState() => _FactureCardState();
}

class _FactureCardState extends State<FactureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final isPayee = widget.facture.cistatus == 'VALID';
    final isEnRetard = widget.facture.cistatus == 'INPROG' &&
        widget.facture.cidocdate.isBefore(DateTime.now());

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: _isPressed ? 8 : 12,
                  offset: _isPressed ? const Offset(0, 2) : const Offset(0, 4),
                  spreadRadius: _isPressed ? 0 : 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colorScheme, isPayee, isEnRetard),
                      const SizedBox(height: 12),
                      _buildInvoiceType(theme, colorScheme),
                      const SizedBox(height: 20),
                      _buildDivider(colorScheme),
                      const SizedBox(height: 20),
                      _buildDetailsGrid(theme, colorScheme),
                      const SizedBox(height: 20),
                      _buildDateInfo(theme, colorScheme),
                      const SizedBox(height: 24),
                      _buildActionButtons(theme, colorScheme, isPayee, isEnRetard),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, bool isPayee, bool isEnRetard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Facture reference - made more prominent
        Text(
          'Facture ${widget.facture.cireference}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),

        // Status and type in a row with consistent spacing
        Row(
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPayee
                    ? Colors.green.shade100
                    : isEnRetard
                    ? Colors.red.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.facture.cistatuslabel.toUpperCase(),
                style: TextStyle(
                  color: isPayee
                      ? Colors.green.shade800
                      : isEnRetard
                      ? Colors.red.shade800
                      : Colors.orange.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Invoice type
            Expanded(
              child: Text(
                widget.facture.citypelabel,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoiceType(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          _getInvoiceIcon(widget.facture.citype),
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          widget.facture.citypelabel,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      color: colorScheme.outline.withOpacity(0.1),
    );
  }

  Widget _buildDetailsGrid(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailItem(
          'Montant total',
          '${widget.facture.cigrosstotal.toStringAsFixed(2)} ${widget.facture.currcode ?? '€'}',
          theme,
          colorScheme,
        ),
        _buildDetailItem(
          'Montant dû',
          '${widget.facture.cidueamount.toStringAsFixed(2)} ${widget.facture.currcode ?? '€'}',
          theme,
          colorScheme,
        ),
      ],
    );
  }

  Widget _buildDetailItem(
      String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Column(
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
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateItem(
          'Date de création',
          _formatDate(widget.facture.cidocdate),
          theme,
          colorScheme,
        ),
        if (widget.facture.ciinvoicetype == 'INVOICE')
          _buildDateItem(
            'Référence client',
            widget.facture.clientname ?? 'N/A',
            theme,
            colorScheme,
          ),
      ],
    );
  }

  Widget _buildDateItem(
      String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Column(
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
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      ThemeData theme, ColorScheme colorScheme, bool isPayee, bool isEnRetard) {
    return Column(
      children: [
        // Primary action buttons row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FactureDetailsPage(facture: widget.facture),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility_rounded, size: 18),
                label: const Text('Voir'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: BorderSide(
                    color: colorScheme.outline.withOpacity(0.5),
                    width: 1,
                  ),
                  foregroundColor: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: widget.onDownloadPressed,
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Télécharger'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: colorScheme.surfaceVariant,
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),

        // Conditional payment action button
        if (!isPayee) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
          ),
        ],
      ],
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
}