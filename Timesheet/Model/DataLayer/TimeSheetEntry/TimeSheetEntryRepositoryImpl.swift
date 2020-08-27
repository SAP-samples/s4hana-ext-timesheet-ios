import SAPFoundation
import SAPOData
import SAPOfflineOData
import SAPCommon

class TimeSheetEntryRepositoryImpl: TimeSheetEntryRepository {

    private var apimanageworkforcetimesheetEntitiesOffline: APIMANAGEWORKFORCETIMESHEETEntities<OfflineODataProvider>!
    private var apimanageworkforcetimesheetEntitiesOnline: APIMANAGEWORKFORCETIMESHEETEntities<OnlineODataProvider>!
    
    private var logger: Logger = Logger.shared(named: "TimeSheetEntryRepositoryImpl")
    
    init(apimanageworkforcetimesheetEntitiesOffline: APIMANAGEWORKFORCETIMESHEETEntities<OfflineODataProvider>, apimanageworkforcetimesheetEntitiesOnline: APIMANAGEWORKFORCETIMESHEETEntities<OnlineODataProvider>){
        self.apimanageworkforcetimesheetEntitiesOffline = apimanageworkforcetimesheetEntitiesOffline
        self.apimanageworkforcetimesheetEntitiesOnline = apimanageworkforcetimesheetEntitiesOnline
    }
    // Fetch the Timesheet Data via the Offline Flow
    func fetchTimeSheetTasksForDate(forDate date: Date, andUserId userId: String) throws -> [TimeSheetEntry] {
        let query = DataQuery()
            .filter(
                TimeSheetEntry.timeSheetDate == LocalDateTime.from(utc: date, in: TimeZone.current)
                    && TimeSheetEntry.personWorkAgreementExternalID == userId)
            .orderBy(TimeSheetEntry.timeSheetDate)
            .orderBy(TimeSheetEntry.yy1StartTimeTIM)
            .orderBy(TimeSheetEntry.yy1EndTimeTIM)
        
        do {
            let fetchResult = try apimanageworkforcetimesheetEntitiesOffline.fetchTimeSheetEntryCollection(matching: query)
            
            // Filter the Tasks out, which have the Status 60. That means these tasks are marked to be deleted.
            return fetchResult
                .filter({$0.timeSheetStatus != "60"})
                .sorted(by: {left, right in
                    if let leftTime = left.yy1StartTimeTIM, let rightTime = right.yy1StartTimeTIM {
                        let timezoneOffsetInHours = TimeZone.current.secondsFromGMT()/3600
                        
                        return leftTime.plusHours(Int64(timezoneOffsetInHours)) < rightTime.plusHours(Int64(timezoneOffsetInHours))
                    }
                    
                    return false
                })
        }
        catch (let error) {
            throw error
        }
    }
    
    // Create Tasks in online mode only
    func createTimeSheetTask(_ task: TimeSheetEntry) throws {
        do {
            return try apimanageworkforcetimesheetEntitiesOnline.createEntity(task)
        }
        catch (let error) {
            throw error
        }
    }
    
    // Upate Tasks in online mode only
    func updateTimeSheetTask(_ task: TimeSheetEntry) throws {
        do {
           return try apimanageworkforcetimesheetEntitiesOnline.createEntity(task)
        }
        catch (let error) {
            logger.warn("Could not update timesheet entry", error: error)
            throw error
        }
    }
    
    // Delete Tasks in online mode only
    func deleteTimeSheetTask(_ task: TimeSheetEntry) throws {
        do {
            return try apimanageworkforcetimesheetEntitiesOnline.createEntity(task)
        }
        catch (let error) {
            logger.warn("Could not delete timesheet entry", error: error)
            throw error
        }
    }
    
}
