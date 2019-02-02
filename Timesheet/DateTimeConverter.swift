import SAPOData

class DateTimeConverter {
    
    /**
     * Formats a decimal number, representing a time in hours and minutes, to and String, represented by time confrom values.
     * - parameter date: Time value as a decimal number representint hours and minutes e.g. 2.25, what would mean 2 hours and 15 minutes
     * - returns: A String, which would return for a input parameter 2.25 the result 2 hr, 15 min
     */
    func formatNumberToTimeString (value: BigDecimal?) -> String {
        
        var formatResult: String = "No Record"
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        if let time = value?.doubleValue() {
            // Convert the value of the input parameter of this method into seconds
            let timeInSconds: TimeInterval = time * 3600
            formatResult = formatter.string(from: timeInSconds)!
            
        }
        return formatResult
    }
    
    /**
     * Sums up the recorded time of the given tasks.
     * - parameter entries: All tasks, whose recorded times are going to be summed up together
     * - returns: Sum of recorded time
     */
    func sumHoursForDay(entries: [TimeSheetEntry]) -> String {
        var sum: BigDecimal = BigDecimal.init(0)
        
        if entries.count > 0 {
            let durationArray = entries.map { $0.timeSheetDataFields?.recordedQuantity }
            for duration in durationArray {
                sum = sum + duration!
            }
        }
        
        return formatNumberToTimeString(value: sum)
    }
    
}
