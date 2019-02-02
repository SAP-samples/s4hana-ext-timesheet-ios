import UIKit
import SAPFiori
import SAPFoundation

protocol TaskTableViewControllerDelegate {
    func onTaskCreated()
}

class TaskTableViewController: FUIFormTableViewController, SAPFioriProgressIndicator {
    
    internal var loadingIndicator: FUIModalProcessingIndicatorView?
    
    private var selectedTaskType: TaskType!
    
    private var timeFormatter = DateFormatter()
    
    private var dateFormatter = DateFormatter()
    
    private var startTime: Date!
    
    private var endTime: Date!
    
    public var selectedDate: Date!
    
    public var timesheetService: TimeSheetAppServiceAPI!
    
    public var taskTableViewControllerDelegate: TaskTableViewControllerDelegate?
    
    // MARK: - View Controller Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Task"
        
        timeFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        
        initDateAndStartTimeAndEndTime()
        selectedTaskType = TaskType.generateStaticTaskTypes().first
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(onSaveTask))
        
        self.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        self.tableView.register(FUIDatePickerFormCell.self, forCellReuseIdentifier: FUIDatePickerFormCell.reuseIdentifier)
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ConnectivityReceiver.registerObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Unregister the connectivity observer to prevent memory leaks
        ConnectivityReceiver.unregisterObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func onCancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func onSaveTask() {
        tableView.endEditing(true)
        readAndUpdatePickerValues()
        
        if isInputValid() {
            saveTask()
        }
    }
    
    // MARK: - Read and Set Values
    
    private func initDateAndStartTimeAndEndTime() {
        let currentTime = Date()
        
        let startHour = Calendar.current.component(.hour, from: currentTime)
        let endHour = Calendar.current.component(.hour, from: currentTime) + 1
        
        startTime = Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: currentTime)
        endTime = Calendar.current.date(bySettingHour: endHour, minute: 0, second: 0, of: currentTime)
        
        if selectedDate == nil {
            selectedDate = Date()
        }
    }
    
    private func readAndUpdatePickerValues() {
        let datePickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FUIDatePickerFormCell
        let startTimePickerCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! FUIDatePickerFormCell
        let endTimePickerCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! FUIDatePickerFormCell
        
        selectedDate = datePickerCell.value
        startTime = startTimePickerCell.value
        endTime = endTimePickerCell.value
    }
    
    // MARK: - Saving the task
    
    private func saveTask() {
        showFioriLoadingIndicator()
        
        timesheetService.createTimesheetTaskType(taskType: selectedTaskType, date: selectedDate, startTime: startTime, endTime: endTime) { [weak self] error in
            self?.hideFioriLoadingIndicator()
            
            if let error = error {
                ErrorAlertHelper.showCouldNotCreateTaskError(error, presentingViewController: self)
            }
            else {
                self?.taskTableViewControllerDelegate?.onTaskCreated()
                self?.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Input Validation
    
    private func isInputValid() -> Bool {
        if startTime > endTime {
            showValidationErrorMessage("Start Time cannot be greater than End Time")
            return false
        }
        
        return true
    }
    
    private func showValidationErrorMessage(_ message: String) {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "OK", style: .default)
        vc.addAction(okAction)
        
        self.present(vc, animated: true)
    }
    
    // MARK: - Navigation
    
    private func navigateToTaskSelection() {
        let vc = ViewControllerFactory.createTaskTypeTableViewController(selectedTaskType: selectedTaskType, taskTypeSelectionDelegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 1: Task type selection section
        // Section 2: Date and time section
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section 1: Task type selection cell
        if section == 0 {
            return 1
        }
        
        // Section 2: Date, start and end time cells
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return createTaskTypeCell(indexPath: indexPath)
        }
        else {
            return createDateAndTimeSelectionCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            navigateToTaskSelection()
        }
    }
    
    private func createTaskTypeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.headlineText = "Task Type"
        cell.subheadlineText = selectedTaskType.timeSheetTaskDescription
        
        return cell
    }
    
    private func createDateAndTimeSelectionCell(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return createDateSelectionCell(indexPath: indexPath)
        }
        else {
            return createTimeSelectionCell(indexPath: indexPath)
        }
    }
    
    // MARK: - Cell Creators

    private func createDateSelectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIDatePickerFormCell.reuseIdentifier, for: indexPath) as! FUIDatePickerFormCell
        cell.keyName = "Date"
        
        cell.setTintColor(self.view.tintColor, for: .normal)
        cell.setTintColor(self.view.tintColor, for: .selected)
        cell.valueTextField.textColor = self.view.tintColor
        
        cell.dateFormatter = dateFormatter
        cell.datePickerMode = .date
        cell.value = selectedDate
        cell.isEnabled = true
        cell.isEditable = true
        cell.isTrackingLiveChanges = false
        
        cell.onChangeHandler = { [weak self] newValue in
            self?.selectedDate = newValue
        }
        
        return cell
    }
    
    private func createTimeSelectionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIDatePickerFormCell.reuseIdentifier, for: indexPath) as! FUIDatePickerFormCell
        
        cell.setTintColor(self.view.tintColor, for: .normal)
        cell.setTintColor(self.view.tintColor, for: .selected)
        cell.valueTextField.textColor = self.view.tintColor
        
        cell.dateFormatter = timeFormatter
        cell.datePickerMode = .time
        cell.isEnabled = true
        cell.isEditable = true
        cell.isTrackingLiveChanges = false
        
        if indexPath.row == 1 {
            cell.keyName = "Start Time"
            cell.value = startTime
            
            cell.onChangeHandler = { [weak self] newTime in
                self?.startTime = newTime
            }
        }
        else if indexPath.row == 2 {
            cell.keyName = "End Time"
            cell.value = endTime
            
            cell.onChangeHandler = { [weak self] newTime in
                self?.endTime = newTime
            }
        }
        
        return cell
    }
    
}

extension TaskTableViewController: TaskTypeSelectionDelegate {
    
    func onSelectTaskType(taskType: TaskType) {
        self.selectedTaskType = taskType
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
    }
    
}

extension TaskTableViewController: ConnectivityObserver {
    
    func connectionEstablished() {
        guard let navBar = self.navigationController?.navigationBar as? FUINavigationBar else {
            return
        }
        BarBannerNotification.positiveResponseBanner(message: "Connected", navigationBar: navBar)
    }
    
    func connectionChanged(_ previousReachabilityType: ReachabilityType, reachabilityType: ReachabilityType) {
        // Information for the transition for connection state change are not required
    }
    
    func connectionLost() {
        guard let navBar = self.navigationController?.navigationBar as? FUINavigationBar else {
            return
        }
        BarBannerNotification.negativeResponseBanner(message: "Connection Lost", navigationBar: navBar)
    }
}
