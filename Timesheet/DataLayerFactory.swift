import Foundation
import SAPOfflineOData

protocol DataLayerFactory {
    
    func getOfflineODataProvider() -> OfflineODataProvider
    
    func getTimeSheetEntryRepository() -> TimeSheetEntryRepository
    
    func getUserRepository() -> UserRepository
    
}
