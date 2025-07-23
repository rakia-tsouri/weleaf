import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/contract.dart';

class ContractDetailsPage extends StatefulWidget {
  final Contract contract;

  const ContractDetailsPage({super.key, required this.contract});

  @override
  State<ContractDetailsPage> createState() => _ContractDetailsPageState();
}

class _ContractDetailsPageState extends State<ContractDetailsPage> {
  bool _showAllDetails = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: Text(
          'Contract #${widget.contract.ctrid}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF4B5563),
        ),
      ),
      body: Column(
        children: [
          // Status Header with dynamic colors
          _buildStatusHeader(context),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Monthly Payment',
                          value: '${widget.contract.cterentalamount.toStringAsFixed(2)} ${widget.contract.currcode}',
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Financed Amount',
                          value: '${widget.contract.ctfinancedamount.toStringAsFixed(2)} ${widget.contract.currcode}',
                          icon: Icons.money_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Duration',
                          value: '${widget.contract.cteduration} months',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Rate',
                          value: '${widget.contract.ctenominalrate.toStringAsFixed(2)}%',
                          icon: Icons.trending_up_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main Details Card
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Contract Details Section
                          _buildCleanSection(
                            title: 'Contract Details',
                            icon: Icons.description_outlined,
                            children: [
                              _buildDetailItem('Reference', widget.contract.ctreference),
                              _buildDetailItem('Description', widget.contract.ctdescription),
                              _buildDetailItem('Offer', widget.contract.offeridlabel),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Client Information Section
                          _buildCleanSection(
                            title: 'Client Information',
                            icon: Icons.business_outlined,
                            children: [
                              _buildDetailItem('Client Name', widget.contract.clientname),
                              _buildDetailItem('Client Reference', widget.contract.clientreference),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Contract Period Section
                          _buildCleanSection(
                            title: 'Contract Period',
                            icon: Icons.date_range_outlined,
                            children: [
                              _buildDetailItem('Start Date', widget.contract.ctestartdate),
                              _buildDetailItem('End Date', widget.contract.cteenddate),
                              _buildDetailItem('Duration', '${widget.contract.cteduration} months'),
                            ],
                          ),

                          if (_showAllDetails) ...[
                            const SizedBox(height: 16),

                            // Financial Terms Section
                            _buildCleanSection(
                              title: 'Financial Terms',
                              icon: Icons.attach_money_outlined,
                              children: [
                                _buildMonetaryItem('Monthly Payment', widget.contract.cterentalamount, widget.contract.currcode),
                                _buildMonetaryItem('Financed Amount', widget.contract.ctfinancedamount, widget.contract.currcode),
                                _buildMonetaryItem('Residual Value', widget.contract.ctervamount, widget.contract.currcode),
                                _buildDetailItem('Nominal Rate', '${widget.contract.ctenominalrate.toStringAsFixed(2)}%'),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Additional Information Section
                            _buildCleanSection(
                              title: 'Additional Information',
                              icon: Icons.info_outline,
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

                          // Show More/Less Button
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAllDetails = !_showAllDetails;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _showAllDetails ? 'Show Less' : 'Show All Details',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    _showAllDetails ? Icons.expand_less : Icons.expand_more,
                                    size: 20,
                                  ),
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
        ],
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color statusColor;
    IconData statusIcon;
    String statusText = widget.contract.statuslabel;

    switch (statusText.toLowerCase()) {
      case 'active':
        statusColor = Colors.green.shade700;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'expiré':
        statusColor = Colors.amber.shade700;
        statusIcon = Icons.timer_off_outlined;
        break;
      default:
        statusColor = theme.primaryColor;
        statusIcon = Icons.info_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : statusColor.withOpacity(0.08),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contract Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          if (widget.contract.cteenddate != null)
            Text(
              'Ends ${widget.contract.cteenddate}',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, {required String title, required String value, required IconData icon}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(icon, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade500),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonetaryItem(String label, double amount, String currency) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' $currency',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
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