import SAPFoundation
import SAPCommon
import SAPOData
import SAPOfflineOData

class DataLayerBackendFactory: DataLayerFactory {
    
    private var sapUrlSession: SAPURLSession!
    
    private var apimanageworkforcetimesheetEntitiesOffline: APIMANAGEWORKFORCETIMESHEETEntities<OfflineODataProvider>!
    
    private var apimanageworkforcetimesheetEntitiesOnline: APIMANAGEWORKFORCETIMESHEETEntities<OnlineODataProvider>!
    
    private var offlineODataProvider: OfflineODataProvider!
    
    private var timeSheetEntryRepository: TimeSheetEntryRepository!
    
    private var offlineDelegate: OfflineODataDelegate!
    
    private var userRepository: UserRepository!
    
    init(sapUrlSession: SAPURLSession) {
        self.sapUrlSession = sapUrlSession
        self.offlineDelegate = OfflineODataDelegateImpl()
        
        self.apimanageworkforcetimesheetEntitiesOffline = DataLayerBackendFactory.createTimesheetOfflineService(sapUrlSession: sapUrlSession, offlineDelegate: offlineDelegate)
        self.offlineODataProvider = self.apimanageworkforcetimesheetEntitiesOffline.provider
        
        self.apimanageworkforcetimesheetEntitiesOnline = DataLayerBackendFactory.createTimesheetOnlineService(sapUrlSession: sapUrlSession)
    }
    
    private static func createTimesheetOfflineService(sapUrlSession: SAPURLSession, offlineDelegate: OfflineODataDelegate) ->  APIMANAGEWORKFORCETIMESHEETEntities<OfflineODataProvider>! {
        let timesheetConnectionId = ServiceConfiguration.getTimesheetServiceConnectionId()
        let serviceDataUrl = ServiceConfiguration.getHostUrl().appendingPathComponent(timesheetConnectionId)
        
        var parameters = OfflineODataParameters.init()
        parameters.storeName = "TimesheetStore"
        parameters.enableRepeatableRequests = false
        
        let provider = try! OfflineODataProvider(serviceRoot: serviceDataUrl, parameters: parameters, sapURLSession: sapUrlSession, delegate: offlineDelegate)
        
        addDefiningRequests(toProvider: provider)
        
        return APIMANAGEWORKFORCETIMESHEETEntities<OfflineODataProvider>(provider: provider)
    }
    
    private static func createTimesheetOnlineService(sapUrlSession: SAPURLSession) ->  APIMANAGEWORKFORCETIMESHEETEntities<OnlineODataProvider>! {
        
        let timesheetConnectionId = ServiceConfiguration.getTimesheetServiceConnectionId()
        let serviceDataUrl = ServiceConfiguration.getHostUrl().appendingPathComponent(timesheetConnectionId)
        let provider = OnlineODataProvider(serviceName: "APIMANAGEWORKFORCETIMESHEETEntities", serviceRoot: serviceDataUrl, sapURLSession: sapUrlSession)
        
        provider.serviceOptions.checkVersion = true
        provider.traceRequests = true
        provider.prettyTracing = true
        provider.traceWithData = true
        
        provider.httpHeaders.setHeader(withName: "Accept-Encoding", value: "application/gzip")
        
        return APIMANAGEWORKFORCETIMESHEETEntities<OnlineODataProvider>(provider: provider)
    }
    
    private static func addDefiningRequests(toProvider provider: OfflineODataProvider) {
        //All deleted timesheet items with the status 60 are deleted ones. We do not want to read them. 
        let timeSheetEntriesDq = OfflineODataDefiningQuery( name: "TimeSheetEntryCollection", query: "TimeSheetEntryCollection", automaticallyRetrievesStreams: false )
                
        try! provider.add(definingQuery: timeSheetEntriesDq)
    }
    
    func getOfflineODataProvider() -> OfflineODataProvider {
        return self.offlineODataProvider
    }
    
    func getTimeSheetEntryRepository() -> TimeSheetEntryRepository {
        if timeSheetEntryRepository == nil {
            timeSheetEntryRepository = TimeSheetEntryRepositoryImpl(apimanageworkforcetimesheetEntitiesOffline: apimanageworkforcetimesheetEntitiesOffline, apimanageworkforcetimesheetEntitiesOnline: apimanageworkforcetimesheetEntitiesOnline)
        }
        
        return timeSheetEntryRepository
    }
    
    func getUserRepository() -> UserRepository {
        if userRepository == nil {
            userRepository = UserRepositoryImpl(sapUrlSession: sapUrlSession)
        }
        
        return userRepository
    }
    
}
