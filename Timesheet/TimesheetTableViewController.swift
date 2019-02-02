import UIKit
import SAPFiori
import SAPOData
import SAPOfflineOData
import SAPFoundation

class TimesheetTableViewController: FUIFormTableViewController, SAPFioriProgressIndicator {
    
    internal var loadingIndicator: FUIModalProcessingIndicatorView?
    
    private let dateFormatter: DateFormatter! = DateFormatter()
    
    private let converter: DateTimeConverter = DateTimeConverter()
    
    private var timeSheetEntries = [TimeSheetEntry]()
    
    private var selectedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    
    private var isDataLoaded = false
    
    public var timesheetService: TimeSheetAppServiceAPI!
    
    public var offlineService: OfflineService!
    
    // We assume the working week is 8 hours long
    public var dailyWorkHours: Double = 8.0
    
    // MARK: - View Controller Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Timesheet"
        
        dateFormatter.dateStyle = .medium
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(onAddTaskPressed))
        
        self.tableView.register(FUITimelineCell.self, forCellReuseIdentifier: FUITimelineCell.reuseIdentifier)
        self.tableView.register(FUIDatePickerFormCell.self, forCellReuseIdentifier: FUIDatePickerFormCell.reuseIdentifier)
        self.tableView.register(FUITimelineMarkerCell.self, forCellReuseIdentifier: FUITimelineMarkerCell.reuseIdentifier)
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderHeight = 0
        self.tableView.sectionFooterHeight = 0
        
        // Swipe down to refresh guesture
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(onPullToRefresh), for: UIControlEvents.valueChanged)
        
        self.updateKPIHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // The displayed Tasks are loaded from the local Database.
        // If the offline store is not opened yet, we open it and sync it with the backend
        // so that we get the most recent data.
        if !offlineService.isOfflineStoreOpened() {
            openOfflineStoreAndDownloadNewData() { [weak self] in
                self?.loadLocalTimeSheetEntries(displayLoadingIndicator: false)
            }
        }
        else if !self.isDataLoaded {
            self.loadLocalTimeSheetEntries()
        }
        
        ConnectivityReceiver.registerObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Unregister the connectivity observer to prevent memory leaks
        ConnectivityReceiver.unregisterObserver(self)
    }
    
    // MARK: - Offline Store Handling
    
    private func openOfflineStoreAndDownloadNewData(completion: @escaping () -> Void) {
        showFioriLoadingIndicator()
        
        offlineService.openOfflineStore() { [weak self] error in
            if let error = error {
                self?.hideFioriLoadingIndicator()
                ErrorAlertHelper.showCouldNotOpenOfflineStoreError(error, presentingViewController: self)
            }
            else {
                self?.downloadNewOfflineData() {
                    self?.hideFioriLoadingIndicator()
                    completion()
                }
            }
        }
    }
    
    private func downloadNewOfflineData(completion: @escaping () -> Void) {
        self.offlineService.download() { error in
            if let error = error {
                if error.code == -10292 {
                    guard let navBar = self.navigationController?.navigationBar as? FUINavigationBar else {
                        return
                    }
                    BarBannerNotification.negativeResponseBanner(message: "App in Offline Mode", navigationBar: navBar)
                }
                else {
                    ErrorAlertHelper.showCouldNotFetchDataError(error, presentingViewController: self)
                }
            }
            
            completion()
        }
    }
    
    // MARK: - Data Fetching
    
    private func loadLocalTimeSheetEntries(displayLoadingIndicator: Bool = true) {
        if displayLoadingIndicator {
            self.showFioriLoadingIndicatorIfPullToRefreshIndicatorIsNotShown()
        }
        
        timesheetService.fetchTimeSheetTasksForDate(forDate: selectedDate) { [weak self] timesheetEntries, error in
            self?.hideFioriLoadingIndicatorIfPullToRefreshIsNotActive()
            self?.isDataLoaded = true
            
            if let error = error {
                ErrorAlertHelper.showCouldNotFetchDataError(error, presentingViewController: self)
            }
            else {
                self?.timeSheetEntries = timesheetEntries
                self?.tableView.reloadData()
                self?.updateKPIHeader()
            }
        }
    }
    
    private func downloadOfflineStore() {
        self.showFioriLoadingIndicatorIfPullToRefreshIndicatorIsNotShown()
        
        offlineService.download() { [weak self] error in
            if let error = error {
                self?.hideFioriLoadingIndicatorIfPullToRefreshIsNotActive()
                ErrorAlertHelper.showCouldNotUploadOfflineStoreError(error, presentingViewController: self)
            }
            else {
                self?.loadLocalTimeSheetEntries(displayLoadingIndicator: false)
            }
        }
    }
    
    // MARK: - KPI Header
    
    private func updateKPIHeader() {
        if let header = self.tableView.tableHeaderView as? FUIKPIHeader {
            if let kpiProgressTimeLeft = header.items[0] as? FUIKPIProgressView {
                setHoursLeftChartKPIValues(kpiView: kpiProgressTimeLeft)
            }
            if let taskAmountKpi = header.items[1] as? FUIKPIView {
                setTaskAmountSimpleKPIValues(kpiView: taskAmountKpi)
            }
            if let extraTimeKpi = header.items[2] as? FUIKPIView {
                setExtraTimeSimpleKPIValues(kpiView: extraTimeKpi)
            }
        }
        else {
            setupAndUpdateKPIHeader()
        }
    }
    
    private func setupAndUpdateKPIHeader() {
        // Progress KPI for the left hours
        var chart: FUIKPIProgressView!
        chart = FUIKPIProgressView()
        chart.captionLabelText = "Hours left to Maintain"

        chart.chartSize = FUIKPIProgressViewSize.large
        chart.colorScheme = .darkBackground
        setHoursLeftChartKPIValues(kpiView: chart)

        // KPI for the amount of tasks
        let taskAmountKpi = buildKPIView(items: [],
                                         captionLabelText: "Records for Today",
                                         isEnabled: true)
        setTaskAmountSimpleKPIValues(kpiView: taskAmountKpi)
        
        // KPI for the extra time
        let extraTimeKpi = buildKPIView(items: [],
                                captionLabelText: "Hours Extratime",
                                         isEnabled: true)
        setExtraTimeSimpleKPIValues(kpiView: extraTimeKpi)
        
        // Create the KPI Header out of the three previous KPI's
        var kpiArray = [FUIKPIContainer]()
        kpiArray = [chart!, taskAmountKpi, extraTimeKpi]
        
        let header = FUIKPIHeader()
        header.items = kpiArray
        
        self.tableView.tableHeaderView  = header
    }
    
    private func setHoursLeftChartKPIValues(kpiView: FUIKPIProgressView) {
        let hoursWorkedQuantity = calculateWorkedHoursQuantityOfCurrentDate()
        var hoursLeftToWork = dailyWorkHours - hoursWorkedQuantity
        
        if hoursLeftToWork < 0.0 {
            hoursLeftToWork = 0.0
        }
        
        let leftHours = FUIKPIMetricItem(string: "\(hoursLeftToWork)")
        kpiView.items = [leftHours]
        kpiView.progress = Float(hoursLeftToWork / dailyWorkHours)
    }
    
    private func setTaskAmountSimpleKPIValues(kpiView: FUIKPIView) {
        let newKpiItem = FUIKPIMetricItem(string: String(timeSheetEntries.count))
        kpiView.items = [newKpiItem]
    }
    
    private func setExtraTimeSimpleKPIValues(kpiView: FUIKPIView) {
        let hoursWorkedQuantity = calculateWorkedHoursQuantityOfCurrentDate()
        var extraTime: Double = 0.0
        
        if hoursWorkedQuantity > dailyWorkHours {
            extraTime = hoursWorkedQuantity - dailyWorkHours
            // Round the Value
            extraTime = (round(1000*extraTime)/1000)
        }
    
        let newKpiItem = FUIKPIMetricItem(string: String(extraTime))
        kpiView.items = [newKpiItem]
    }
    
    private func buildKPIView(items: [FUIKPIViewItem], captionLabelText: String = "", captionLabelLines: Int = 1, isEnabled: Bool = true) -> FUIKPIView {
        let kpiView = FUIKPIView()
        kpiView.items = items
        kpiView.captionlabel.text = captionLabelText
        kpiView.captionlabel.numberOfLines = captionLabelLines
        kpiView.tintColor = UIColor(hexString: "CAE4FB")
        kpiView.isEnabled = isEnabled
        
        return kpiView
    }
    
    private func calculateWorkedHoursQuantityOfCurrentDate() -> Double {
       return timeSheetEntries
            .map({$0.timeSheetDataFields?.recordedQuantity?.doubleValue() ?? 0.0})
            .reduce(0.0, {return $0 + $1})
    }
    
    // MARK: - Loading Indicator Logic
    
    private func showFioriLoadingIndicatorIfPullToRefreshIndicatorIsNotShown() {
        guard let refreshControl = self.refreshControl else { return }
        
        if !refreshControl.isRefreshing {
            self.showFioriLoadingIndicator()
        }
    }
    
    private func hideFioriLoadingIndicatorIfPullToRefreshIsNotActive() {
        self.hideFioriLoadingIndicator()
        guard let refreshControl = self.refreshControl else { return }
        
        if refreshControl.isRefreshing == true {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Delete the Task
    
    private func deleteTask(task: TimeSheetEntry) {
        timesheetService.deleteTimeSheetTaskType(taskEntry: task) { error in
            if let error = error {
                ErrorAlertHelper.showCouldNotCreateTaskError(error, presentingViewController: self)
            }
            else {
                // Reload the data from the backend to keep the local
                // offline store in sync with the backend.
                self.downloadOfflineStore()
            }
        }
    }
    
    // MARK: - Navigation
    
    private func showUpdateTimesheetEntryScreen(timesheetEntryToUpdate timesheetEntry: TimeSheetEntry) {
        let vc = ViewControllerFactory.createUpdateTaskTableViewController(timesheetEntryToUpdate: timesheetEntry, preselectedDate: selectedDate, updateTaskTableViewControllerDelegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onAddTaskPressed() {
        let vc = ViewControllerFactory.createTaskTableViewController(preselectedDate: selectedDate, taskTableViewControllerDelegate: self)
        let nvc = UINavigationController(navigationBarClass: FUINavigationBar.self, toolbarClass: nil)
        
        nvc.viewControllers = [vc]
        self.present(nvc, animated: true)
    }
    
    // MARK: - Refresh Offline Store
    
    @objc private func onPullToRefresh() {
        self.downloadOfflineStore()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 1: Date Value Picker
        // Section 2: Timeline Cell Start Node
        // Section 3: Timeline Cells for the Tasks
        // Section 4: Timeline Cell End Node
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Section 1: Date Value Picker
        case 0:
            return 1
        // Section 2: Timeline Cell Start Node
        case 1:
            return 1
        // Section 3: Timeline Cells for the Tasks
        case 2:
            return timeSheetEntries.count == 0 ? 1 : timeSheetEntries.count
        // Section 4: Timeline Cell End Node
        case 3:
            return 1
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Section 1: Date Value Picker
        case 0:
            return createDatePickerCell(indexPath: indexPath)
        // Section 2: Timeline Cell Start Node
        case 1:
            return createStartTimelineNode(indexPath: indexPath)
        // Section 3: Timeline Cells for the Tasks
        case 2:
            if timeSheetEntries.count == 0 {
                // Insert an empty timeline cell, stating that no entries are existing
                return createEmptyTimelineNode(indexPath: indexPath)
            } else {
                return createTimeSheetEntryCell(indexPath: indexPath)
            }
        // Section 4: Timeline Cell End Node
        case 3:
            return createEndTimelineNode(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        // Section 1: Date Value Picker
        case 0:
            return false
        // Section 2: Timeline Cell Start Node
        case 1:
            return false
        // Section 3: Timeline Cells for the Tasks
        case 2:
            return true
        // Section 4: Timeline Cell End Node
        case 3:
            return false
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Spacing between KpiHeader and Datevalue Picker
        if section == 0 {
            return 30
        }
        // Spacing between Datevalue Picker and Timeline Cells
        else if section == 1 {
            return 30
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteTimeSheetEntryCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        // Section 1: Date Value Picker
        case 0:
            super.tableView(tableView, didSelectRowAt: indexPath)
        // Section 2: Timeline Cell Start Node
        case 1:
            super.tableView(tableView, didSelectRowAt: indexPath)
        // Section 3: Timeline Cells for the Tasks
        case 2:
            let entry = timeSheetEntries[indexPath.row]
            showUpdateTimesheetEntryScreen(timesheetEntryToUpdate: entry)
        // Section 4: Timeline Cell End Node
        case 3:
            super.tableView(tableView, didSelectRowAt: indexPath)
        default: break
        }
    }
    
    // MARK: - Date Value Picker
    
    private func createDatePickerCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIDatePickerFormCell.reuseIdentifier, for: indexPath) as! FUIDatePickerFormCell
        cell.keyName = "Date"
        
        cell.setTintColor(self.view.tintColor, for: .normal)
        cell.setTintColor(self.view.tintColor, for: .selected)
        cell.valueTextField.textColor = self.view.tintColor
        
        cell.dateFormatter = dateFormatter
        cell.datePickerMode = .date
        cell.value = cell.dateFormatter!.date(from: dateFormatter.string(from: selectedDate))!
        cell.isEnabled = true
        cell.isEditable = true
        cell.isTrackingLiveChanges = false
        
        cell.onChangeHandler = { [weak self] newValue in
            self?.selectedDate = newValue
            
            //Here we wait a bit until the collapse animation of the date picker cell is finished
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self?.loadLocalTimeSheetEntries()
            }
        }
        
        return cell
    }
    
    // MARK: - Cell Creators
    
    private func createTimeSheetEntryCell(indexPath: IndexPath) -> UITableViewCell {
        
        let timelineCell = tableView.dequeueReusableCell(withIdentifier: FUITimelineCell.reuseIdentifier, for: indexPath) as! FUITimelineCell
        
        let entry = timeSheetEntries[indexPath.row]
        
        timelineCell.timelineWidth = CGFloat(95.0)
        if let taskTypeAbbreviation = entry.timeSheetDataFields?.timeSheetTaskType {
            if let taskType = TaskType.taskType(forTaskTypeAbbreviation: taskTypeAbbreviation) {
                timelineCell.headlineText = taskType.timeSheetTaskDescription
                
                // Define here the Timeline cell Icons for each task type
                switch taskTypeAbbreviation {
                case "ADMI":
                    timelineCell.eventImage = FUIIconLibrary.map.marker.jobSmall
                case "TRAV":
                    timelineCell.eventImage = FUIIconLibrary.map.marker.busSmall
                case "MISC":
                    timelineCell.eventImage = FUIIconLibrary.system.shuffle
                default:
                    timelineCell.eventImage = FUIIconLibrary.system.flagOn
                }
                
            } else {
                timelineCell.headlineText = taskTypeAbbreviation
            }
        } else {
            timelineCell.headlineText = "Task Type not available"
        }
        
        timelineCell.attributeText = " "
        
        timelineCell.nodeImage = FUITimelineNode.open
        
        if let startTime = entry.yy1StartTimeTIM, let endTime = entry.yy1EndTimeTIM {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "UTC")!
            
            let startDate = calendar.date(bySettingHour: startTime.hour, minute: startTime.minute, second: startTime.minute, of: Date())
            let endDate = calendar.date(bySettingHour: endTime.hour, minute: endTime.minute, second: endTime.minute, of: Date())
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            
            timelineCell.eventText =  timeFormatter.string(from: startDate!)
            
            timelineCell.subheadlineText = "\(timeFormatter.string(from: startDate!)) - \(timeFormatter.string(from: endDate!))"
            
            timelineCell.subStatusText = converter.formatNumberToTimeString(value: entry.timeSheetDataFields?.recordedQuantity)
        }
        return timelineCell
    }
    
    private func createStartTimelineNode(indexPath: IndexPath) -> UITableViewCell {
        let timelineMarkerCell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier, for: indexPath) as! FUITimelineMarkerCell
        timelineMarkerCell.timelineWidth = CGFloat(95.0)
        timelineMarkerCell.titleText = "Recording Start"
        if let timeSheetDate = timeSheetEntries.first?.timeSheetDate?.utc() {
            timelineMarkerCell.eventText = dateFormatter.string(from: timeSheetDate)
        }
        timelineMarkerCell.nodeImage = FUITimelineNode.start
        timelineMarkerCell.showLeadingTimeline = false
        timelineMarkerCell.showTrailingTimeline = true
        
        return timelineMarkerCell
    }
    
    private func createEndTimelineNode(indexPath: IndexPath) -> UITableViewCell {
        let timelineMarkerCell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier, for: indexPath) as! FUITimelineMarkerCell
        timelineMarkerCell.timelineWidth = CGFloat(95.0)
        timelineMarkerCell.eventText = "End of Recording"
        timelineMarkerCell.titleText = "Total time for today: \(converter.sumHoursForDay(entries: timeSheetEntries))"
        timelineMarkerCell.nodeImage = FUITimelineNode.end
        timelineMarkerCell.showLeadingTimeline = true
        timelineMarkerCell.showTrailingTimeline = false
        return timelineMarkerCell
    }
    
    private func createEmptyTimelineNode(indexPath: IndexPath) -> UITableViewCell {
        let timelineMarkerCell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier, for: indexPath) as! FUITimelineMarkerCell
        timelineMarkerCell.timelineWidth = CGFloat(95.0)
        timelineMarkerCell.titleText = "No entries for today"
        timelineMarkerCell.nodeImage = FUITimelineNode.inactive
        timelineMarkerCell.showLeadingTimeline = true
        timelineMarkerCell.showTrailingTimeline = true
        return timelineMarkerCell
    }
    
    // MARK: - Cell Deletion
    
    private func deleteTimeSheetEntryCell(indexPath: IndexPath) -> Void {
        let entry = timeSheetEntries[indexPath.row]
        self.deleteTask(task: entry)
    }
    
}

extension TimesheetTableViewController: UpdateTaskTableViewControllerDelegate, TaskTableViewControllerDelegate {
    
    func onTaskCreated() {
        self.downloadOfflineStore()
    }
    
    func onTaskUpdated() {
        self.downloadOfflineStore()
    }
    
}

extension TimesheetTableViewController: ConnectivityObserver {
    
    func connectionEstablished() {
        guard let navBar = self.navigationController?.navigationBar as? FUINavigationBar else {
            return
        }
        BarBannerNotification.positiveResponseBanner(message: "Connected", navigationBar: navBar)
        // Refresh the local Store automatically one the connection is established
        self.downloadOfflineStore()
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
