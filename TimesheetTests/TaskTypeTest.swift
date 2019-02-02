import XCTest
@testable import Timesheet

class TaskTypeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testWhenGenerateStaticTaskTypes_thenResultIsCorrect() {
        let types = TaskType.generateStaticTaskTypes()
        
        XCTAssertNotNil(types)
        
        XCTAssertNotNil(types.first(where: {t in t.timeSheetTaskType == "ADMI"}))
        XCTAssertNotNil(types.first(where: {t in t.timeSheetTaskType == "TRAV"}))
        XCTAssertNotNil(types.first(where: {t in t.timeSheetTaskType == "MISC"}))
    }
    
    func testWhenTaskTypeForTaskTypeAbbreviation_thenResultIsCorrect() {
        XCTAssertNotNil(TaskType.taskType(forTaskTypeAbbreviation: "ADMI"))
        XCTAssertNil(TaskType.taskType(forTaskTypeAbbreviation: "123"))
    }
    
}
