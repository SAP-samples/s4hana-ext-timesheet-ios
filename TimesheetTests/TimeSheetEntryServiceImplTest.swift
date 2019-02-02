import XCTest
@testable import Timesheet

class TimeSheetEntryServiceImplTest: XCTestCase {
    
    private var userRepositoryMock: UserRepositoryMock!
    
    private var timeSheetEntryRepositoryMock: TimeSheetEntryRepositoryMock!
    
    private var timesheetEntryService: TimeSheetEntryService!
    
    override func setUp() {
        super.setUp()
        
        userRepositoryMock = UserRepositoryMock()
        timeSheetEntryRepositoryMock = TimeSheetEntryRepositoryMock()
        
        timesheetEntryService = TimeSheetEntryServiceImpl(timeSheetEntryRepository: timeSheetEntryRepositoryMock, userRepository: userRepositoryMock)
    }
    
    func testWhenFetchTimeSheetTasksForDate_thenResultIsCorrect() {
        timeSheetEntryRepositoryMock.fetchTimeSheetTasksForDateResult = TestDataGenerator.generateTimeSheetEntries()
        
        timesheetEntryService.fetchTimeSheetTasksForDate(forDate: Date()) { timeSheetEntries, error in
            XCTAssertEqual(timeSheetEntries, TestDataGenerator.generateTimeSheetEntries())
        }
    }
    
    func testWhenCreateTimesheetTaskType_thenCorrectRepositoryMethodIsCalled() {
        timeSheetEntryRepositoryMock.createTimeSheetTaskWasCalledNTimes = 0
        userRepositoryMock.fetchUsernameResult = "EMPLOYEE"
        
        timesheetEntryService.createTimesheetTaskType(taskType: TaskType.taskType(forTaskTypeAbbreviation: "ADMI")!, date: Date(), startTime: Date(), endTime: Date()) { error in
            XCTAssertEqual(1, self.timeSheetEntryRepositoryMock.createTimeSheetTaskWasCalledNTimes)
        }
    }
    
    func testWhenUpdateTimeSheetTask_thenCorrectRepositoryMethodIsCalled() {
        let entry = TestDataGenerator.generateTimeSheetEntries().first!
        
        timesheetEntryService.updateTimeSheetTaskType(taskEntry: entry, date: Date(), startTime: Date(), endTime: Date()) { error in
            XCTAssertEqual(1, self.timeSheetEntryRepositoryMock.updateTimeSheetTaskWasCalledNTimes)
        }
    }
    
    func testWhenDeleteTimeSheetTask_thenCorrectRepositoryMethodIsCalled() {
        let entry = TestDataGenerator.generateTimeSheetEntries().first!
        
        timesheetEntryService.deleteTimeSheetTaskType(taskEntry: entry) { error in
            XCTAssertEqual(1, self.timeSheetEntryRepositoryMock.deleteTimeSheetTaskWasCalledNTimes)
        }
    }
    
}
