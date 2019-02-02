import SAPFoundation
import SAPOData
import SAPOfflineOData
@testable import Timesheet

class TimeSheetODataServiceOfflineMock: APIMANAGEWORKFORCETIMESHEETEntities<OfflineODataProvider> {
    
    public var fetchTimeSheetEntryCollectionResult: [TimeSheetEntry]!
    public var fetchTimeSheetEntryCollectionExecutedQuery: DataQuery!
    
    public static func createInstance() -> TimeSheetODataServiceOfflineMock {
        let params = OfflineODataParameters()
        let provider = try! OfflineODataProvider.init(serviceRoot: URL.init(string: "https://some.url.com")!, parameters: params)
        
        return TimeSheetODataServiceOfflineMock(provider: provider)
    }
    
    override func fetchTimeSheetEntryCollection(matching query: DataQuery) throws -> Array<TimeSheetEntry> {
        fetchTimeSheetEntryCollectionExecutedQuery = query
        
        return fetchTimeSheetEntryCollectionResult
    }
    
}
