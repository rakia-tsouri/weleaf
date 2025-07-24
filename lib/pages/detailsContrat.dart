import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/contract.dart';

class ContractDetailsPage extends StatefulWidget {
  final Contract contract;

  const ContractDetailsPage({super.key, required this.contract});

  @override
  State<ContractDetailsPage> createState() => _ContractDetailsPageState();
}

class _ContractDetailsPageState extends State<ContractDetailsPage>
    with SingleTickerProviderStateMixin {
  bool _showAllDetails = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F0F0F)
          : const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: Text(
          'Contract #${widget.contract.ctrid}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
        backgroundColor: isDarkMode
            ? const Color(0xFF1A1A1A)
            : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        scrolledUnderElevation: 8,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  colorScheme.outline.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Enhanced Status Header
          _buildStatusHeader(context),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // Enhanced Summary Cards
                  _buildSummaryCardsGrid(context),
                  const SizedBox(height: 24),
                  // Enhanced Main Details Card
                  _buildMainDetailsCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    Color statusColor;
    IconData statusIcon;
    String statusText = widget.contract.statuslabel;

    switch (statusText.toLowerCase()) {
      case 'active':
        statusColor = Colors.green.shade600;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'expiré':
        statusColor = Colors.amber.shade600;
        statusIcon = Icons.schedule_rounded;
        break;
      default:
        statusColor = colorScheme.primary;
        statusIcon = Icons.info_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(isDarkMode ? 0.15 : 0.08),
            statusColor.withOpacity(isDarkMode ? 0.08 : 0.04),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'status-${widget.contract.ctrid}',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contract Status',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (widget.contract.cteenddate != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Ends ${widget.contract.cteenddate}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                title: 'Monthly Payment',
                value: '${widget.contract.cterentalamount.toStringAsFixed(2)} ${widget.contract.currcode}',
                icon: Icons.payments_rounded,
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.1), Colors.blue.withOpacity(0.05)],
                ),
                iconColor: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                context,
                title: 'Financed Amount',
                value: '${widget.contract.ctfinancedamount.toStringAsFixed(2)} ${widget.contract.currcode}',
                icon: Icons.account_balance_wallet_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xFFAFAD4C).withOpacity(0.1), Color(0xFFAFAD4C).withOpacity(0.05)],
                ),
                iconColor: Color(0xFFAFAD4C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                title: 'Duration',
                value: '${widget.contract.cteduration} months',
                icon: Icons.schedule_rounded,
                gradient: LinearGradient(
                  colors: [Colors.orange.withOpacity(0.1), Colors.orange.withOpacity(0.05)],
                ),
                iconColor: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                context,
                title: 'Rate',
                value: '${widget.contract.ctenominalrate.toStringAsFixed(2)}%',
                icon: Icons.trending_up_rounded,
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent.withOpacity(0.1), Colors.pinkAccent.withOpacity(0.05)],
                ),
                iconColor: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Gradient gradient,
        required Color iconColor,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12, // Reduced from 13 to 12
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.2, // Added line height for better spacing
                  ),
                  maxLines: 2, // Allow text to wrap to 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced from 12 to 10 to balance the space
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
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

  Widget _buildMainDetailsCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
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
                : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contract Details Section
            _buildCleanSection(
              title: 'Contract Details',
              icon: Icons.description_rounded,
              children: [
                _buildDetailItem('Reference', widget.contract.ctreference),
                _buildDetailItem('Description', widget.contract.ctdescription),
                _buildDetailItem('Offer', widget.contract.offeridlabel),
              ],
            ),
            _buildSectionDivider(),

            // Client Information Section
            _buildCleanSection(
              title: 'Client Information',
              icon: Icons.business_rounded,
              children: [
                _buildDetailItem('Client Name', widget.contract.clientname),
                _buildDetailItem('Client Reference', widget.contract.clientreference),
              ],
            ),
            _buildSectionDivider(),

            // Contract Period Section
            _buildCleanSection(
              title: 'Contract Period',
              icon: Icons.date_range_rounded,
              children: [
                _buildDetailItem('Start Date', widget.contract.ctestartdate),
                _buildDetailItem('End Date', widget.contract.cteenddate),
                _buildDetailItem('Duration', '${widget.contract.cteduration} months'),
              ],
            ),

            // Expandable sections
            if (_showAllDetails) ...[
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildSectionDivider(),
                    _buildCleanSection(
                      title: 'Financial Terms',
                      icon: Icons.attach_money_rounded,
                      children: [
                        _buildMonetaryItem('Monthly Payment', widget.contract.cterentalamount, widget.contract.currcode),
                        _buildMonetaryItem('Financed Amount', widget.contract.ctfinancedamount, widget.contract.currcode),
                        _buildMonetaryItem('Residual Value', widget.contract.ctervamount, widget.contract.currcode),
                        _buildDetailItem('Nominal Rate', '${widget.contract.ctenominalrate.toStringAsFixed(2)}%'),
                      ],
                    ),
                    _buildSectionDivider(),
                    _buildCleanSection(
                      title: 'Additional Information',
                      icon: Icons.info_rounded,
                      children: [
                        if (widget.contract.ctactivationdate != null)
                          _buildDetailItem(
                              'Activation Date',
                              '${widget.contract.ctactivationdate!.day}/${widget.contract.ctactivationdate!.month}/${widget.contract.ctactivationdate!.year}'
                          ),
                        _buildDetailItem('Proposal Reference', widget.contract.propreference),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            // Enhanced Show More/Less Button
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      setState(() {
                        _showAllDetails = !_showAllDetails;
                      });
                      if (_showAllDetails) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showAllDetails ? 'Show Less' : 'Show All Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            turns: _showAllDetails ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.expand_more_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildSectionDivider() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
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
      ),
    );
  }

  Widget _buildCleanSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonetaryItem(String label, double amount, String currency) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  TextSpan(
                    text: ' $currency',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
