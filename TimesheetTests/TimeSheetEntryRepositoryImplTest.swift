import XCTest
import SAPOData
@testable import Timesheet

class TimeSheetEntryRepositoryImplTest: XCTestCase {
    
    private var onlineServiceMock: TimeSheetODataServiceOnlineMock!
    
    private var offlineServiceMock: TimeSheetODataServiceOfflineMock!
    
    private var timeSheetEntryRepository: TimeSheetEntryRepository!
    
    override func setUp() {
        super.setUp()
        
        onlineServiceMock = TimeSheetODataServiceOnlineMock.createInstance()
        
        offlineServiceMock = TimeSheetODataServiceOfflineMock.createInstance()
        
        timeSheetEntryRepository = TimeSheetEntryRepositoryImpl(apimanageworkforcetimesheetEntitiesOffline: offlineServiceMock, apimanageworkforcetimesheetEntitiesOnline: onlineServiceMock)
    }
    
    func testWhenFetchTimeSheetTasksForDate_thenResultIsCorrect() throws {
        offlineServiceMock.fetchTimeSheetEntryCollectionResult = TestDataGenerator.generateTimeSheetEntries()
        
        let date = Date()
        
        let entries = try timeSheetEntryRepository.fetchTimeSheetTasksForDate(forDate: date, andUserId: "EMPLOYEE")
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss"
        
        XCTAssertEqual(entries, TestDataGenerator.generateTimeSheetEntries())

    }
    
    // Test without Custom Fields
    func testWhenCreateTimeSheetTaskW_thenCreateIsCalledOnODataService() throws {
        let entry = TestDataGenerator.generateTimeSheetEntries().first!
        entry.timeSheetOperation = "C"
        
        onlineServiceMock.createEntityWasCalledNTimes = 0
        
        try timeSheetEntryRepository.createTimeSheetTask(entry)
        
        XCTAssertEqual(onlineServiceMock.createEntityWasCalledNTimes, 1)
    }
        
    func testWhenUpdateTimeSheetTask_thenUpdateIsCalledOnODataService() throws {
        let entry = TestDataGenerator.generateTimeSheetEntries().first!
        entry.timeSheetOperation = "U"
        
        onlineServiceMock.createEntityWasCalledNTimes = 0
        
        //The timesheet service uses post requests for updating entries
        try timeSheetEntryRepository.createTimeSheetTask(entry)
        
        XCTAssertEqual(onlineServiceMock.createEntityWasCalledNTimes, 1)
    }
    
    func testWhenDeleteTimeSheetTask_thenDeleteIsCalledOnODataService() throws {
        let entry = TestDataGenerator.generateTimeSheetEntries().first!
        entry.timeSheetOperation = "D"
        
        onlineServiceMock.createEntityWasCalledNTimes = 0
        
        //The timesheet service uses post requests to delete entries
        try timeSheetEntryRepository.createTimeSheetTask(entry)
        
        XCTAssertEqual(onlineServiceMock.createEntityWasCalledNTimes, 1)
    }
    
}
