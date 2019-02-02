import Foundation

protocol TimeSheetEntryRepository {
    
    func fetchTimeSheetTasksForDate(forDate date: Date, andUserId userId: String) throws -> [TimeSheetEntry]
    
    func createTimeSheetTask(_ task: TimeSheetEntry) throws -> Void
    
    func updateTimeSheetTask(_ task: TimeSheetEntry) throws -> Void
    
    func deleteTimeSheetTask(_ task: TimeSheetEntry) throws -> Void
    
}
