import Foundation

protocol TimeSheetEntryService {
    
    func fetchTimeSheetTasksForDate(forDate date: Date, completion: @escaping ([TimeSheetEntry], Error?) -> Void)
    
    func createTimesheetTaskType(taskType: TaskType, date: Date, startTime: Date, endTime: Date, completion: @escaping (Error?) -> Void)
    
    func updateTimeSheetTaskType(taskEntry: TimeSheetEntry, date: Date, startTime: Date, endTime: Date, completion: @escaping (Error?) -> Void)
    
    func deleteTimeSheetTaskType(taskEntry: TimeSheetEntry, completion: @escaping (Error?) -> Void)
    
}
