import Foundation
import SAPOfflineOData
import SAPCommon

class OfflineODataDelegateImpl: OfflineODataDelegate {
    
    private let logger = Logger.shared(named: "OfflineODataDelegateImpl")
    
    func offlineODataProvider(_ provider: OfflineODataProvider, didUpdateDownloadProgress progress: OfflineODataProgress) {
        logger.info("didUpdateDownloadProgress bytes received: \(progress.bytesReceived)")
    }
    
    func offlineODataProvider(_ provider: OfflineODataProvider, didUpdateFileDownloadProgress progress: OfflineODataFileDownloadProgress) {
        logger.info("didUpdateFileDownloadProgress: \(progress.bytesReceived)")
    }
    
    func offlineODataProvider(_ provider: OfflineODataProvider, didUpdateUploadProgress progress: OfflineODataProgress) {
        logger.info("didUpdateUploadProgress: \(progress.bytesSent)")
    }
    
    func offlineODataProvider(_ provider: OfflineODataProvider, requestDidFail request: OfflineODataFailedRequest) {
        logger.info("requestDidFail: \(request.errorMessage)")
    }
    
    func offlineODataProvider(_ provider: OfflineODataProvider, stateDidChange newState: OfflineODataStoreState) {
        logger.info("stateDidChange: \(newState.rawValue)")
    }
    
}
