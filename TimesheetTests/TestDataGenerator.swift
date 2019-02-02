import Foundation
import SAPOData
@testable import Timesheet

class TestDataGenerator {
    
    public static func generateTimeSheetEntries() -> [TimeSheetEntry] {
        let e1 = TimeSheetEntry()
        e1.companyCode = "10"
        e1.personWorkAgreementExternalID = "EMPLOYEE"
        
        let timesheetData = TimeSheetDataFields()
        e1.timeSheetDataFields = timesheetData
        
        return [e1]
    }
}

