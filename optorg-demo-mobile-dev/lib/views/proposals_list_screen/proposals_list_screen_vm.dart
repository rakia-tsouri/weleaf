import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/data/repositories/proposal_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class ProposalsListScreenVM extends ChangeNotifier {
  ProposalsRepository proposalsRepository = ProposalsRepository();
  User? connectedUser;
  // *************
  // *************
  Future<ApiResponse<ProposalListResponse>> getListOfProposals(
      {required int offset}) async {
    connectedUser = await AppDataStore().getUserInfo();
    if (connectedUser != null) {
      ApiResponse<ProposalListResponse> response_2 =
          await proposalsRepository.getProposalsList(offset: offset);
      if (response_2.isSuccess()) {
        return response_2;
      }
    }

    return ApiResponse.error(ERROR_OCCURED);
  }

  // *************
  // *************
  Future<ApiResponse<ProposalDetailsResponse>> getProposalDetails(
      {required int proposalId}) async {
    ApiResponse<ProposalDetailsResponse> response_2 =
        await proposalsRepository.getProposalDetails(proposalid: proposalId);
    if (response_2.isSuccess()) {
      if (response_2.data != null &&
          response_2.data!.data != null &&
          response_2.data!.data!.assets != null) {
        int? assetId = response_2.data!.data!.assets!.first.assetid;
        if (assetId != null) {
          ApiResponse<AssetServicesResponse> responseAssetServices =
              await getAssetServicesList(assetId: assetId);
          if (responseAssetServices.isSuccess() &&
              responseAssetServices.data != null) {
            response_2.data!.data!.assetServiceList =
                responseAssetServices.data!.list;
          }
        }
      }
      return response_2;
    }

    return ApiResponse.error(ERROR_OCCURED);
  }

  // *************
  // *************
  Future<ApiResponse<AssetServicesResponse>> getAssetServicesList(
      {required int assetId}) async {
    ApiResponse<AssetServicesResponse> response_2 =
        await proposalsRepository.getAssetSeriveList(assetId: assetId);
    if (response_2.isSuccess()) {
      return response_2;
    }

    return ApiResponse.error(ERROR_OCCURED);
  }
}
