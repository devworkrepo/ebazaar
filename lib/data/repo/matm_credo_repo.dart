import '../../model/common.dart';
import '../../model/matm_credo/matm_credo_initiate.dart';

abstract class MatmCredoRepo {
  Future<MatmCredoInitiate> initiateTransaction(data);
  Future<CommonResponse> updateMatmDataToServer(data);
}