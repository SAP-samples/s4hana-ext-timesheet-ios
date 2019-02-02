import Foundation
import SAPOfflineOData

protocol OfflineService {
    
    func isOfflineStoreOpened() -> Bool
    
    func openOfflineStore(completion: @escaping (OfflineODataError?) -> Void)
    
    func upload(completion: @escaping (OfflineODataError?) -> Void)
    
    func download(completion: @escaping (OfflineODataError?) -> Void)
    
    func closeOfflineStore() -> Void
    
}
