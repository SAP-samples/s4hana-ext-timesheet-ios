import Foundation
import SAPOfflineOData
import SAPCommon

class OfflineODataDelegateImpl: OfflineODataProviderDelegate {
    
    private let logger = Logger.shared(named: "OfflineODataDelegateImpl")
    
    func offlineODataProvider(_: OfflineODataProvider, didUpdateOpenProgress progress: OfflineODataProviderOperationProgress) {
        self.logger.info("openProgress: \(progress.defaultMessage)")
    }

    func offlineODataProvider(_: OfflineODataProvider, didUpdateDownloadProgress progress: OfflineODataProviderDownloadProgress) {
        self.logger.info("downloadProgress: \(progress.defaultMessage)")
    }

    func offlineODataProvider(_: OfflineODataProvider, didUpdateUploadProgress progress: OfflineODataProviderOperationProgress) {
        self.logger.info("uploadProgress: \(progress.defaultMessage)")
    }

    func offlineODataProvider(_: OfflineODataProvider, requestDidFail request: OfflineODataFailedRequest) {
        self.logger.info("requestFailed: \(request.httpStatusCode)")
    }

    func offlineODataProvider(_: OfflineODataProvider, didUpdateSendStoreProgress progress: OfflineODataProviderOperationProgress) {
        self.logger.info("sendStoreProgress: \(progress.defaultMessage)")
    }
    
}
