//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

internal class APIMANAGEWORKFORCETIMESHEETEntitiesStaticResolver: ObjectBase {
    override init() {
    }

    class func resolve() -> Void {
        APIMANAGEWORKFORCETIMESHEETEntitiesStaticResolver.resolve1()
    }

    private class func resolve1() -> Void {
        Ignore.valueOf_any(APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields)
        Ignore.valueOf_any(APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry)
        Ignore.valueOf_any(APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntitySets.timeSheetEntryCollection)
        Ignore.valueOf_any(TimeSheetDataFields.controllingArea)
        Ignore.valueOf_any(TimeSheetDataFields.senderCostCenter)
        Ignore.valueOf_any(TimeSheetDataFields.receiverCostCenter)
        Ignore.valueOf_any(TimeSheetDataFields.internalOrder)
        Ignore.valueOf_any(TimeSheetDataFields.activityType)
        Ignore.valueOf_any(TimeSheetDataFields.wbsElement)
        Ignore.valueOf_any(TimeSheetDataFields.workItem)
        Ignore.valueOf_any(TimeSheetDataFields.billingControlCategory)
        Ignore.valueOf_any(TimeSheetDataFields.purchaseOrder)
        Ignore.valueOf_any(TimeSheetDataFields.purchaseOrderItem)
        Ignore.valueOf_any(TimeSheetDataFields.timeSheetTaskType)
        Ignore.valueOf_any(TimeSheetDataFields.timeSheetTaskLevel)
        Ignore.valueOf_any(TimeSheetDataFields.timeSheetTaskComponent)
        Ignore.valueOf_any(TimeSheetDataFields.timeSheetNote)
        Ignore.valueOf_any(TimeSheetDataFields.recordedHours)
        Ignore.valueOf_any(TimeSheetDataFields.recordedQuantity)
        Ignore.valueOf_any(TimeSheetDataFields.hoursUnitOfMeasure)
        Ignore.valueOf_any(TimeSheetDataFields.rejectionReason)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetDataFields)
        Ignore.valueOf_any(TimeSheetEntry.personWorkAgreementExternalID)
        Ignore.valueOf_any(TimeSheetEntry.companyCode)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetRecord)
        Ignore.valueOf_any(TimeSheetEntry.personWorkAgreement)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetDate)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetIsReleasedOnSave)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetPredecessorRecord)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetStatus)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetIsExecutedInTestRun)
        Ignore.valueOf_any(TimeSheetEntry.timeSheetOperation)
        Ignore.valueOf_any(TimeSheetEntry.yy1EndTimeTIM)
        Ignore.valueOf_any(TimeSheetEntry.yy1StartTimeTIM)
        Ignore.valueOf_any(TimeSheetEntry.yy1EndTimeTIMF)
        Ignore.valueOf_any(TimeSheetEntry.yy1StartTimeTIMF)
    }
}
