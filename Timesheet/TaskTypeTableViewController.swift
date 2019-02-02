import UIKit

protocol TaskTypeSelectionDelegate {
    func onSelectTaskType(taskType: TaskType)
}

class TaskTypeTableViewController: UITableViewController {
    
    private var taskTypes = [TaskType]()
    
    public var selectedTaskType: TaskType!
    
    public var taskTypeSelectionDelegate: TaskTypeSelectionDelegate?
    
    public var timesheetService: TimeSheetAppServiceAPI!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Task Type"
        
        setTaskTypes()
    }
    
    private func setTaskTypes() {
        taskTypes = TaskType.generateStaticTaskTypes()
        
        if selectedTaskType == nil {
            selectedTaskType = taskTypes.first
        }
    }
    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskTypes[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "taskTypeCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "taskTypeCell")
        }
        
        cell?.textLabel?.text = task.timeSheetTaskDescription
        
        if task == selectedTaskType {
            cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = taskTypeSelectionDelegate {
            delegate.onSelectTaskType(taskType: taskTypes[indexPath.row])
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
