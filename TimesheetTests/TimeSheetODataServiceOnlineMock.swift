import SAPFoundation
import SAPOData
@testable import Timesheet

class TimeSheetODataServiceOnlineMock: APIMANAGEWORKFORCETIMESHEETEntities<OnlineODataProvider> {
    
    public var fetchTimeSheetEntryCollectionResult: [TimeSheetEntry]!
    public var fetchTimeSheetEntryCollectionExecutedQuery: DataQuery!
    
    public var createEntityWasCalledNTimes = 0
    
    public static func createInstance() -> TimeSheetODataServiceOnlineMock {
        let provider = OnlineODataProvider.init(serviceRoot: URL.init(string: "https://some.url.com")!)
        
        return TimeSheetODataServiceOnlineMock(provider: provider)
    }
    
    override func fetchTimeSheetEntryCollection(matching query: DataQuery) throws -> Array<TimeSheetEntry> {
        fetchTimeSheetEntryCollectionExecutedQuery = query
        
        return fetchTimeSheetEntryCollectionResult
    }
    
    override func createEntity(_ entity: EntityValue, headers: HTTPHeaders, options: RequestOptions) throws {
        createEntityWasCalledNTimes += 1
    }
    
}
