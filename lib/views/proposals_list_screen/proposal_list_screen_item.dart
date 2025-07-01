import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/cached_image.dart';

import 'package:optorg_mobile/widgets/textview.dart';


class ProposalListScreenItem extends StatelessWidget {
  final Proposal proposal;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const ProposalListScreenItem({
    required this.proposal,
    required this.onTap,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: PADDING_10.heightResponsive()),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(PADDING_12.widthResponsive()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(),
                SizedBox(height: PADDING_8.heightResponsive()),
                _buildDescription(),
                SizedBox(height: PADDING_8.heightResponsive()),
                _buildDetailsRow(),
                SizedBox(height: PADDING_12.heightResponsive()),
                _buildActionButtons(),
              ],
            ),
          ),
          _buildProductImage(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: formatDate(proposal.ctstatusdate),
                textColor: Colors.grey,
                textSize: 12,
              ),
              SizedBox(height: PADDING_4.heightResponsive()),
              TextView(
                text: proposal.propreference ?? 'N/A',
                textColor: PRIMARY_BLUE_COLOR,
                textSize: 16,
                isBold: true,
              ),
            ],
          ),
        ),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    final statusInfo = _getStatusInfo();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: PADDING_8.widthResponsive(),
        vertical: PADDING_4.heightResponsive(),
      ),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusInfo.label,
        style: TextStyle(
          color: statusInfo.color,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(
          text: "BIEN",
          textColor: Colors.grey,
          textSize: 12,
        ),
        TextView(
          text: proposal.ctdescription ?? 'N/A',
          textColor: Colors.black,
          textSize: 14,
        ),
      ],
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: "MONTANT À FINANCER",
                textColor: Colors.grey,
                textSize: 12,
              ),
              TextView(
                text: proposal.ctfinancedamount?.toDouble().amountFormat() ?? 'N/A',
                textColor: Colors.black,
                textSize: 14,
              ),
            ],
          ),
        ),
        SizedBox(width: PADDING_20.widthResponsive()),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: "LOYER MENSUEL",
                textColor: Colors.grey,
                textSize: 12,
              ),
              TextView(
                text: "${proposal.cterentalamount?.toDouble().amountFormat()} €",
                textColor: Colors.black,
                textSize: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(Icons.visibility, size: 16),
            label: Text('Voir détails'),
            style: OutlinedButton.styleFrom(
              foregroundColor: PRIMARY_BLUE_COLOR,
              side: BorderSide(color: PRIMARY_BLUE_COLOR),
            ),
          ),
        ),
        SizedBox(width: PADDING_8.widthResponsive()),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.edit, size: 16),
            label: Text('Modifier'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: BorderSide(color: Colors.orange),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return Positioned(
      top: PADDING_10.heightResponsive(),
      right: PADDING_10.widthResponsive(),
      child: SizedBox(
        width: PADDING_80.widthResponsive(),
        height: PADDING_60.heightResponsive(),
        child: PagerCachedImage(
          url: _getProductImageUrl(proposal.ctdescription),
          boxFit: BoxFit.contain,
          onErrorBuilder: () => Image.asset(OFFER_DEFAULT_CAR),
        ),
      ),
    );
  }

  String _getProductImageUrl(String? productDescription) {
    if (productDescription == null) return "";

    final desc = productDescription.toLowerCase();

    if (desc.contains("volkswagen")) return "https://www.logo-voiture.com/wp-content/uploads/2021/01/Logo-Volkswagen.png";
    if (desc.contains("peugeot")) return "https://logo-marque.com/wp-content/uploads/2021/10/Peugeot-Logo.png";
    if (desc.contains("dacia")) return "https://upload.wikimedia.org/wikipedia/commons/a/a1/Dacia-logo.png";
    if (desc.contains("citroen")) return "https://mediaresource.sfo2.digitaloceanspaces.com/wp-content/uploads/2024/04/20225621/citroen-new-2022-logo-B8E6FFA65E-seeklogo.com.png";
    if (desc.contains("volvo")) return "https://www.logo-voiture.com/wp-content/uploads/2023/03/logo-volvo.png";
    if (desc.contains("jeep")) return "https://www.logo-voiture.com/wp-content/uploads/2021/01/Logo-Jeep.png";
    if (desc.contains("bmw")) return "https://www.carlogos.org/logo/BMW-logo-2000-2048x2048.png";
    if (desc.contains("mercedes")) return "https://www.carlogos.org/logo/Mercedes-Benz-logo-2011-1920x1080.png";

    return proposal.assetpictureurl ?? "";
  }

  ({Color color, String label}) _getStatusInfo() {
    if (proposal.ctstatus?.contains("SCOCREATED") == true) {
      return (color: PRIMARY_YELLOW_COLOR, label: "Brouillon");
    } else if (proposal.ctstatus?.contains("INIT") == true) {
      return (color: Color.fromARGB(255, 14, 0, 168), label: "Envoyée");
    } else if (proposal.ctstatus?.contains("OFFCOMPLTE") == true) {
      return (color: Colors.green, label: "Acceptée");
    } else {
      return (color: Colors.red, label: "Refusée");
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "";
    DateTime? dateTime = dateString.toDateTime();
    return dateTime.format(pattern: 'dd/MM/yyyy') ?? '';
  }
}
