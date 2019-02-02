import Foundation
import SAPOData


class TimeSheetEntryServiceImpl: TimeSheetEntryService {
    
    private enum OperationType: String {
        case create = "C", delete = "D", update = "U"
    }
    
    private var timeSheetEntryRepository: TimeSheetEntryRepository!
    
    private var userRepository: UserRepository!
    
    private let converter: DateTimeConverter = DateTimeConverter()
    
    init(timeSheetEntryRepository: TimeSheetEntryRepository, userRepository: UserRepository) {
        self.timeSheetEntryRepository = timeSheetEntryRepository
        self.userRepository = userRepository
    }
    
    func fetchTimeSheetTasksForDate(forDate date: Date, completion: @escaping ([TimeSheetEntry], Error?) -> Void) {
        do {
            let username = try userRepository.fetchUsername()
            let timeSheetEntries = try timeSheetEntryRepository.fetchTimeSheetTasksForDate(forDate: date, andUserId: username)
            
            completion(timeSheetEntries, nil)
        }
        catch (let error) {
            completion([], error)
        }
    }
    
    func createTimesheetTaskType(taskType: TaskType, date: Date, startTime: Date, endTime: Date, completion: @escaping (Error?) -> Void ) {
        do {
            let username = try userRepository.fetchUsername()
            
            let task = TimeSheetEntry()
            task.personWorkAgreementExternalID = username
            
            task.companyCode = "1010"
            
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
            task.timeSheetDate = LocalDateTime.from(utc: date, in: TimeZone.current)
            task.timeSheetOperation = OperationType.create.rawValue
            task.yy1StartTimeTIM = LocalTime.from(utc: startTime, in: TimeZone.init(abbreviation: "UTC")!)
            task.yy1EndTimeTIM = LocalTime.from(utc: endTime, in: TimeZone.init(abbreviation: "UTC")!)
            
            let timesheetData = TimeSheetDataFields()
            timesheetData.timeSheetTaskType = taskType.timeSheetTaskType
            timesheetData.timeSheetTaskLevel = "NONE"
            timesheetData.timeSheetTaskComponent = "WORK"
            timesheetData.recordedHours = calculateRecordedHours(startTime: startTime, endTime: endTime)
            timesheetData.hoursUnitOfMeasure = "H"
            task.timeSheetDataFields = timesheetData
            
            try timeSheetEntryRepository.createTimeSheetTask(task)
            completion(nil)
        }
        catch (let error) {
            completion(error)
        }
    }
    
    private func calculateRecordedHours(startTime: Date, endTime: Date) -> BigDecimal {
        let recordedHours = Calendar.current.dateComponents([.hour], from: startTime, to: endTime).hour!
        let recordedMinutes = Calendar.current.dateComponents([.minute], from: startTime, to: endTime).minute! % 60

        let recordedMinutesInPercent: Double = Double(recordedMinutes) / 60.0

        return BigDecimal.fromDouble(Double(recordedHours) + recordedMinutesInPercent)
    }
    
    func updateTimeSheetTaskType(taskEntry: TimeSheetEntry, date: Date, startTime: Date, endTime: Date, completion: @escaping (Error?) -> Void) {
        taskEntry.timeSheetOperation = OperationType.update.rawValue
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        taskEntry.timeSheetDate = LocalDateTime.from(utc: date, in: TimeZone.current)
        taskEntry.yy1StartTimeTIM = LocalTime.from(utc: startTime, in: TimeZone.init(abbreviation: "UTC")!)
        taskEntry.yy1EndTimeTIM = LocalTime.from(utc: endTime, in: TimeZone.init(abbreviation: "UTC")!)
        
        taskEntry.timeSheetDataFields?.recordedHours = calculateRecordedHours(startTime: startTime, endTime: endTime)
        
        do {
            try timeSheetEntryRepository.updateTimeSheetTask(taskEntry)
            completion(nil)
        }
        catch (let error) {
            completion(error)
        }
    }
        
    func deleteTimeSheetTaskType(taskEntry: TimeSheetEntry, completion: @escaping (Error?) -> Void) {
        taskEntry.timeSheetOperation = OperationType.delete.rawValue
        
        do {
            try timeSheetEntryRepository.deleteTimeSheetTask(taskEntry)
            completion(nil)
        }
        catch (let error) {
            completion(error)
        }
    }
}
