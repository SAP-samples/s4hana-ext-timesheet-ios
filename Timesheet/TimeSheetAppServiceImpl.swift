import Foundation

class TimeSheetAppServiceImpl: TimeSheetAppServiceAPI {
    
    private var timeSheetEntryService: TimeSheetEntryService!
    
    init(timeSheetEntryService: TimeSheetEntryService) {
        self.timeSheetEntryService = timeSheetEntryService
    }
    
    func fetchTimeSheetTasksForDate(forDate date: Date, completion: @escaping ([TimeSheetEntry], Error?) -> Void) {
        DispatchQueue.global().async {
            self.timeSheetEntryService.fetchTimeSheetTasksForDate(forDate: date) { tasks, error in
                DispatchQueue.main.async {
                    completion(tasks, error)
                }
            }
        }
    }
    
    func createTimesheetTaskType(taskType: TaskType, date: Date, startTime: Date, endTime: Date, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            self.timeSheetEntryService.createTimesheetTaskType(taskType: taskType, date: date, startTime: startTime, endTime: endTime) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func updateTimeSheetTaskType(taskEntry: TimeSheetEntry, date: Date, startTime: Date, endTime: Date, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            self.timeSheetEntryService.updateTimeSheetTaskType(taskEntry: taskEntry, date: date, startTime: startTime, endTime: endTime) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func deleteTimeSheetTaskType(taskEntry: TimeSheetEntry, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            self.timeSheetEntryService.deleteTimeSheetTaskType(taskEntry: taskEntry) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

}
