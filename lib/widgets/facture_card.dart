import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/pages/FactureDetailsPage.dart';
import 'package:optorg_mobile/data/repositories/facture_repository.dart';

class FactureCard extends StatefulWidget {
  final Facture facture;
  final VoidCallback? onActionPressed;

  const FactureCard({
    super.key,
    required this.facture,
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
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
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
                onTap: () => _navigateToDetails(context),
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? colorScheme.surface
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDarkMode
                          ? colorScheme.outline.withOpacity(0.3)
                          : colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(theme, colorScheme, isDarkMode),
                        const SizedBox(height: 16),
                        _buildReference(theme, colorScheme),
                        const SizedBox(height: 20),
                        _buildDivider(colorScheme),
                        const SizedBox(height: 20),
                        _buildDetailsGrid(theme, colorScheme, isDarkMode),
                        const SizedBox(height: 16),
                        _buildDateInfo(theme, colorScheme),
                        const SizedBox(height: 24),
                        _buildActionButton(theme, colorScheme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme, bool isDarkMode) {
    final isPayee = widget.facture.cistatus == 'PAID';
    final isEnRetard = widget.facture.cistatus == 'INPROG' &&
        widget.facture.cidocdate.isBefore(DateTime.now());

    return Row(
      children: [
        Hero(
          tag: 'facture-icon-${widget.facture.cireference}',
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              _getInvoiceIcon(widget.facture.citype),
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
                widget.facture.citypelabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (widget.facture.clientname != null)
                Text(
                  widget.facture.clientname!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildStatusChip(colorScheme, isPayee, isEnRetard),
      ],
    );
  }

  Widget _buildStatusChip(ColorScheme colorScheme, bool isPayee, bool isEnRetard) {
    Color statusColor;
    String statusLabel;

    if (isPayee) {
      statusColor = Colors.green;
      statusLabel = 'Payée';
    } else if (isEnRetard) {
      statusColor = Colors.red;
      statusLabel = 'En cours';
    } else {
      statusColor = Colors.orange;
      statusLabel = 'En attente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReference(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tag_rounded,
            size: 16,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          Text(
            'Référence: ${widget.facture.cireference}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            colorScheme.outline.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(ThemeData theme, ColorScheme colorScheme, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            title: 'Montant total',
            value: '${widget.facture.cigrosstotal.toStringAsFixed(2)} ${widget.facture.currcode ?? '€'}',
            icon: Icons.payments_rounded,
            theme: theme,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDetailItem(
            title: 'Montant dû',
            value: '${widget.facture.cidueamount.toStringAsFixed(2)} ${widget.facture.currcode ?? '€'}',
            icon: Icons.account_balance_wallet_rounded,
            theme: theme,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Text(
            'Date de création: ${_formatDate(widget.facture.cidocdate)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary.withOpacity(0.1),
          foregroundColor: colorScheme.primary,
        ),
        onPressed: () => _navigateToDetails(context),
        icon: const Icon(
          Icons.visibility_rounded,
          size: 20,
        ),
        label: Text(
          'Voir les détails',
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FactureDetailsPage(
              facture: widget.facture,
              factureRepository: FactureRepository(), // Ajoutez cette ligne
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
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
      case 'RV':
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