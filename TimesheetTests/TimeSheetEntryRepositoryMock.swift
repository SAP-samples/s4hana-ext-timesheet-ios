import Foundation
@testable import Timesheet

class TimeSheetEntryRepositoryMock: TimeSheetEntryRepository {
    
    public var fetchTimeSheetTasksForDateResult: [TimeSheetEntry]!
    
    public var createTimeSheetTaskWasCalledNTimes = 0
    
    public var updateTimeSheetTaskWasCalledNTimes = 0
    
    public var deleteTimeSheetTaskWasCalledNTimes = 0
    
    func fetchTimeSheetTasksForDate(forDate date: Date, andUserId userId: String) throws -> [TimeSheetEntry] {
        return fetchTimeSheetTasksForDateResult
    }
    
    func createTimeSheetTask(_ task: TimeSheetEntry) throws {
        createTimeSheetTaskWasCalledNTimes += 1
    }
    
    func updateTimeSheetTask(_ task: TimeSheetEntry) throws {
        updateTimeSheetTaskWasCalledNTimes += 1
    }
    
    func deleteTimeSheetTask(_ task: TimeSheetEntry) throws {
        deleteTimeSheetTaskWasCalledNTimes += 1
    }

}
