import Foundation

class ServiceFactory {
    
    private static var timeSheetEntryService: TimeSheetEntryService!
    
    private static var offlineService: OfflineService!
    
    private init() {
    
    }
    
    public static func getTimeSheetEntryService() -> TimeSheetEntryService {
        if timeSheetEntryService == nil {
            let timeSheetEntryRepository = DataLayerFactoryProvider.shared.getTimeSheetEntryRepository()
            let userRepository = DataLayerFactoryProvider.shared.getUserRepository()
            
            timeSheetEntryService = TimeSheetEntryServiceImpl(timeSheetEntryRepository: timeSheetEntryRepository, userRepository: userRepository)
        }
        
        return timeSheetEntryService
    }
    
    public static func getOfflineService() -> OfflineService {
        if offlineService == nil {
            let provider = DataLayerFactoryProvider.shared.getOfflineODataProvider()
            
            offlineService = OfflineServiceImpl(offlineProvider: provider)
        }
        
        return offlineService
    }
    
}
