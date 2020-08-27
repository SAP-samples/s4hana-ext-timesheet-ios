import Foundation

class TaskType: Equatable {
    
    public private(set) var timeSheetTaskType: String!
    
    public private(set) var timeSheetTaskDescription: String!
    
    init(timeSheetTaskType: String, timeSheetTaskDescription: String) {
        self.timeSheetTaskType = timeSheetTaskType
        self.timeSheetTaskDescription = timeSheetTaskDescription
    }
    
    public static func generateStaticTaskTypes() -> [TaskType] {
        var taskTypes = [TaskType]()
        
        let admin = TaskType(timeSheetTaskType: "ADMI", timeSheetTaskDescription: "Administration")
        let training = TaskType(timeSheetTaskType: "TRAV", timeSheetTaskDescription: "Travel")
        let misc = TaskType(timeSheetTaskType: "MISC", timeSheetTaskDescription: "Miscellaneous")
        
        taskTypes.append(admin)
        taskTypes.append(training)
        taskTypes.append(misc)
        
        return taskTypes
    }
    
    public static func taskType(forTaskTypeAbbreviation taskTypeAbbreviation: String) -> TaskType? {
        for type in generateStaticTaskTypes() {
            if type.timeSheetTaskType == taskTypeAbbreviation {
                return type
            }
        }
        
        return nil
    }
    
    static func == (lhs: TaskType, rhs: TaskType) -> Bool {
        return lhs.timeSheetTaskDescription == rhs.timeSheetTaskDescription
            && lhs.timeSheetTaskType == rhs.timeSheetTaskType
    }
    
}
