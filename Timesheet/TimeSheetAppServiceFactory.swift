import SAPFoundation
import SAPOData
import SAPCommon

class TimeSheetAppServiceFactory {
    
    public static var shared: TimeSheetAppServiceFactory!
    
    private var timeSheetAppService: TimeSheetAppServiceAPI!
    
    private init() {
        
    }
    
    public static func initSharedInstance(sapUrlSession: SAPURLSession) {
        DataLayerFactoryProvider.initSharedInstance(sapUrlSession: sapUrlSession)
        
        setNetworkTimeout(urlSession: sapUrlSession)
        initLogger()
        
        let timeSheetEntryService = ServiceFactory.getTimeSheetEntryService()
        
        shared = TimeSheetAppServiceFactory()
        shared.timeSheetAppService = TimeSheetAppServiceImpl(timeSheetEntryService: timeSheetEntryService)
    }
    
    public func getTimeSheetService() -> TimeSheetAppServiceAPI {
        return timeSheetAppService
    }
    
    private static func setNetworkTimeout(urlSession: SAPURLSession) {
        urlSession.configuration.timeoutIntervalForRequest = 180.0
        urlSession.configuration.timeoutIntervalForResource = 180.0
    }
    
    private static func initLogger() {
        Logger.shared(named: "SAP.OData").logLevel = .debug
    }
    
}
