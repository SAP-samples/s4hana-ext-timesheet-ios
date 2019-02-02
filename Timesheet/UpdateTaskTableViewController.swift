import UIKit
import SAPFiori
import SAPOData
import SAPFoundation

protocol UpdateTaskTableViewControllerDelegate {
    func onTaskUpdated()
}

class UpdateTaskTableViewController: FUIFormTableViewController, SAPFioriProgressIndicator {
    
    internal var loadingIndicator: FUIModalProcessingIndicatorView?
    
    private var selectedTaskType: TaskType!
    
    private var timeFormatter = DateFormatter()
    
    private var dateFormatter = DateFormatter()
    
    private let converter: DateTimeConverter = DateTimeConverter()
    
    private var startTime: Date!
    
    private var endTime: Date!
    
    public var selectedDate: Date!
    
    public var timesheetService: TimeSheetAppServiceAPI!
    
    public var offlineService: OfflineService!
    
    public var timesheetEntry: TimeSheetEntry!
    
    public var updateTaskTableViewControllerDelegate: UpdateTaskTableViewControllerDelegate?
    
    // MARK: - View Controller Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Update Task"
        
        timeFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        
        initDateAndStartTimeAndEndTime()
        selectedTaskType = TaskType.taskType(forTaskTypeAbbreviation: timesheetEntry.timeSheetDataFields?.timeSheetTaskType ?? "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(onUpdateTask))
        
        self.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        self.tableView.register(FUIDatePickerFormCell.self, forCellReuseIdentifier: FUIDatePickerFormCell.reuseIdentifier)
        self.tableView.register(FUITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        ConnectivityReceiver.registerObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Unregister the connectivity observer to prevent memory leaks
        ConnectivityReceiver.unregisterObserver(self)
    }
    
    // MARK: - Actions
    
    @objc private func onUpdateTask() {
        tableView.endEditing(true)
        readAndUpdatePickerValues()
        updateTimeSheetEntryValues()
        
        if isInputValid() {
            updateTask()
        }
    }
    
    // MARK: - Read and Set Values
    
    private func initDateAndStartTimeAndEndTime() {
        let sheetStartTime = timesheetEntry.yy1StartTimeTIM ?? LocalTime.from(utc: Date())
        let sheetEndTime = timesheetEntry.yy1EndTimeTIM ?? LocalTime.from(utc: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        selectedDate = timesheetEntry.timeSheetDate?.utc(from: TimeZone.current) ?? Date()
        
        startTime = calendar.date(bySettingHour: sheetStartTime.hour, minute: sheetStartTime.minute, second: sheetStartTime.second, of: selectedDate)
        endTime = calendar.date(bySettingHour: sheetEndTime.hour, minute: sheetEndTime.minute, second: sheetEndTime.second, of: selectedDate)
    }
    
    private func readAndUpdatePickerValues() {
        let startTimePickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FUIDatePickerFormCell
        let endTimePickerCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! FUIDatePickerFormCell
        
        startTime = startTimePickerCell.value
        endTime = endTimePickerCell.value
    }
    
    private func updateTimeSheetEntryValues() {
        timesheetEntry.timeSheetDataFields?.timeSheetTaskType = self.selectedTaskType.timeSheetTaskType
        timesheetEntry.timeSheetDate = LocalDateTime.from(utc: selectedDate, in: TimeZone.init(abbreviation: "UTC")!)
        timesheetEntry.yy1StartTimeTIM = LocalTime.from(utc: startTime, in: TimeZone.init(abbreviation: "UTC")!)
        timesheetEntry.yy1EndTimeTIM = LocalTime.from(utc: endTime, in: TimeZone.init(abbreviation: "UTC")!)
    }
    
    // MARK: - Saving the task
    
    private func updateTask() {
        showFioriLoadingIndicator()
        
        timesheetService.updateTimeSheetTaskType(taskEntry: timesheetEntry, date: selectedDate, startTime: startTime, endTime: endTime) { [weak self] error in
            self?.hideFioriLoadingIndicator()
            
            if let error = error {
                ErrorAlertHelper.showCouldNotCreateTaskError(error, presentingViewController: self)
            }
            else {
                self?.updateTaskTableViewControllerDelegate?.onTaskUpdated()
                self?.navigationController?.popViewController(animated: true)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return createTaskTypeCell(indexPath: indexPath)
        }
        
        return createTimeSelectionCell(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            navigateToTaskSelection()
        }
    }
    
    // MARK: - Cell Creators
    
    private func createTaskTypeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.headlineText = "Task Type"
        cell.subheadlineText = selectedTaskType.timeSheetTaskDescription
        
        return cell
    }
    
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
        
        if indexPath.row == 0 {
            cell.keyName = "Start Time"
            cell.value = startTime
            
            cell.onChangeHandler = { [weak self] newTime in
                self?.startTime = newTime
            }
        }
        else if indexPath.row == 1 {
            cell.keyName = "End Time"
            cell.value = endTime
            
            cell.onChangeHandler = { [weak self] newTime in
                self?.endTime = newTime
            }
        }
        
        return cell
    }
    
}

extension UpdateTaskTableViewController: TaskTypeSelectionDelegate {
    
    func onSelectTaskType(taskType: TaskType) {
        self.selectedTaskType = taskType
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
    }
    
}

extension UpdateTaskTableViewController: ConnectivityObserver {
    
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
