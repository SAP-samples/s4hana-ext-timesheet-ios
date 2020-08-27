import Foundation

class ViewControllerFactory {
    
    public static func createTimesheetViewController() -> TimesheetTableViewController {
        let vc = TimesheetTableViewController(nibName: "TimesheetTableViewController", bundle: Bundle.main)
        
        vc.timesheetService = TimeSheetAppServiceFactory.shared.getTimeSheetService()
        vc.offlineService = ServiceFactory.getOfflineService()
        
        return vc
    }
    
    public static func createTaskTableViewController(preselectedDate: Date, taskTableViewControllerDelegate: TaskTableViewControllerDelegate) -> TaskTableViewController {
        let vc = TaskTableViewController(nibName: "TaskTableViewController", bundle: Bundle.main)
        
        vc.timesheetService = TimeSheetAppServiceFactory.shared.getTimeSheetService()
        vc.taskTableViewControllerDelegate = taskTableViewControllerDelegate
        vc.selectedDate = preselectedDate
        
        return vc
    }
    
    public static func createTaskTypeTableViewController(selectedTaskType: TaskType, taskTypeSelectionDelegate: TaskTypeSelectionDelegate) -> TaskTypeTableViewController {
        let vc = TaskTypeTableViewController(nibName: "TaskTypeTableViewController", bundle: Bundle.main)
        
        vc.selectedTaskType = selectedTaskType
        vc.taskTypeSelectionDelegate = taskTypeSelectionDelegate
        vc.timesheetService = TimeSheetAppServiceFactory.shared.getTimeSheetService()
        
        
        return vc
    }
    
    public static func createUpdateTaskTableViewController(timesheetEntryToUpdate timesheetEntry: TimeSheetEntry,  preselectedDate: Date, updateTaskTableViewControllerDelegate: UpdateTaskTableViewControllerDelegate) -> UpdateTaskTableViewController {
        let vc = UpdateTaskTableViewController(nibName: "UpdateTaskTableViewController", bundle: Bundle.main)
        
        vc.timesheetService = TimeSheetAppServiceFactory.shared.getTimeSheetService()
        vc.offlineService = ServiceFactory.getOfflineService()
        vc.timesheetEntry = timesheetEntry
        vc.updateTaskTableViewControllerDelegate = updateTaskTableViewControllerDelegate
        vc.selectedDate = preselectedDate
        
        return vc
    }
    
}

