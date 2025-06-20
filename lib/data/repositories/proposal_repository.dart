import 'package:optorg_mobile/constants/api_constants.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/data/models/get_file_response.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/data/repositories/app_repository.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class ProposalsRepository extends AppRepository {
  // **************
  // **************
  Future<ApiResponse<ProposalListResponse>> getProposalsList(
      {required int offset}) async {
    try {
      var response = await dioWithToken.get(
        PROPOSALS_LIST_API,
      );
      ProposalListResponse proposalListResponse =
          ProposalListResponse.fromJson(response.data);
      return ApiResponse.completed(proposalListResponse);
    } catch (ex) {
      return ApiResponse.error(ERROR_OCCURED);
    }
  }

  // **************
  // **************
  Future<ApiResponse<ProposalDetailsResponse>> getProposalDetails(
      {required int proposalid}) async {
    try {
      var response = await dioWithToken.get(
        PROPOSAL_DETAILS_API.format([proposalid]),
      );
      ProposalDetailsResponse _proposalDetailsResponse =
          ProposalDetailsResponse.fromJson(response.data);

      if (_proposalDetailsResponse.data?.assetpictureurl != null) {
        ApiResponse<GetFileResponse> responseFile = await getFileAssetPicture(
            fileName: _proposalDetailsResponse.data!.assetpictureurl!);
        if (responseFile.isSuccess()) {
          _proposalDetailsResponse.data!.assetpictureBase64 =
              responseFile.data?.description;
        }
      }

      return ApiResponse.completed(_proposalDetailsResponse);
    } catch (ex) {
      return ApiResponse.error(ERROR_OCCURED);
    }
  }

// **************
  // **************
  Future<ApiResponse<AssetServicesResponse>> getAssetSeriveList(
      {required int assetId}) async {
    try {
      var response = await dioWithToken.get(
        GET_ASSET_SERVICES_API.format([assetId]),
      );
      AssetServicesResponse proposalListResponse =
          AssetServicesResponse.fromJson(response.data);
      return ApiResponse.completed(proposalListResponse);
    } catch (ex) {
      return ApiResponse.error(ERROR_OCCURED);
    }
  }

  // **************
  // **************
  Future<ApiResponse<GetFileResponse>> getFileAssetPicture(
      {required String fileName}) async {
    try {
      var response = await dioWithToken.post(
        GET_FILE_API.format([fileName]),
      );
      GetFileResponse _getFileResponse =
          GetFileResponse.fromJson(response.data);
      return ApiResponse.completed(_getFileResponse);
    } catch (ex) {
      return ApiResponse.error(ERROR_OCCURED);
    }
  }
}
