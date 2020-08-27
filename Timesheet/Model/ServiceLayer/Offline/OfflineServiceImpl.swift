import Foundation
import SAPOfflineOData
import SAPCommon
import SAPOData

class OfflineServiceImpl: OfflineService {
    
    private let logger = Logger.shared(named: "OfflineServiceImpl")
    
    private var offlineProvider: OfflineODataProvider!
    
    private var isOfflineStoreOpen = false
    
    init(offlineProvider: OfflineODataProvider) {
        self.offlineProvider = offlineProvider
    }
    
    func isOfflineStoreOpened() -> Bool {
        return isOfflineStoreOpen
    }
    
    func openOfflineStore(completion: @escaping (OfflineODataError?) -> Void) {
        offlineProvider.open() { error in
            if let error = error {
                self.logger.warn("Could not open offline store", error: error)
            }
            else {
                self.isOfflineStoreOpen = true
            }
            
            completion(error)
        }
    }
    
    func upload(completion: @escaping (OfflineODataError?) -> Void) {
        offlineProvider.upload() { error in
            if let error = error {
                self.logger.warn("Could not upload offline store", error: error)
            }
            completion(error)
        }
    }
    
    func download(completion: @escaping (OfflineODataError?) -> Void) {
        offlineProvider.download() { error in
            if let error = error {
                self.logger.warn("Could not download new data", error: error)
            }
            
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func closeOfflineStore() {
        try? offlineProvider.close()
    }
    
}
