//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

internal class APIMANAGEWORKFORCETIMESHEETEntitiesMetadataChanges: ObjectBase {
    override init() {
    }

    class func merge(metadata: CSDLDocument) -> Void {
        metadata.hasGeneratedProxies = true
        APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.document = metadata
        APIMANAGEWORKFORCETIMESHEETEntitiesMetadataChanges.merge1(metadata: metadata)
        try! APIMANAGEWORKFORCETIMESHEETEntitiesFactory.registerAll()
    }

    private class func merge1(metadata: CSDLDocument) -> Void {
        Ignore.valueOf_any(metadata)
        if !APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.isRemoved {
            APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields = metadata.complexType(withName: "API_MANAGE_WORKFORCE_TIMESHEET.TimeSheetDataFields")
        }
        if !APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.isRemoved {
            APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry = metadata.entityType(withName: "API_MANAGE_WORKFORCE_TIMESHEET.TimeSheetEntry")
        }
        if !APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntitySets.timeSheetEntryCollection.isRemoved {
            APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntitySets.timeSheetEntryCollection = metadata.entitySet(withName: "TimeSheetEntryCollection")
        }
        if !TimeSheetDataFields.controllingArea.isRemoved {
            TimeSheetDataFields.controllingArea = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "ControllingArea")
        }
        if !TimeSheetDataFields.senderCostCenter.isRemoved {
            TimeSheetDataFields.senderCostCenter = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "SenderCostCenter")
        }
        if !TimeSheetDataFields.receiverCostCenter.isRemoved {
            TimeSheetDataFields.receiverCostCenter = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "ReceiverCostCenter")
        }
        if !TimeSheetDataFields.internalOrder.isRemoved {
            TimeSheetDataFields.internalOrder = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "InternalOrder")
        }
        if !TimeSheetDataFields.activityType.isRemoved {
            TimeSheetDataFields.activityType = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "ActivityType")
        }
        if !TimeSheetDataFields.wbsElement.isRemoved {
            TimeSheetDataFields.wbsElement = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "WBSElement")
        }
        if !TimeSheetDataFields.workItem.isRemoved {
            TimeSheetDataFields.workItem = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "WorkItem")
        }
        if !TimeSheetDataFields.billingControlCategory.isRemoved {
            TimeSheetDataFields.billingControlCategory = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "BillingControlCategory")
        }
        if !TimeSheetDataFields.purchaseOrder.isRemoved {
            TimeSheetDataFields.purchaseOrder = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "PurchaseOrder")
        }
        if !TimeSheetDataFields.purchaseOrderItem.isRemoved {
            TimeSheetDataFields.purchaseOrderItem = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "PurchaseOrderItem")
        }
        if !TimeSheetDataFields.timeSheetTaskType.isRemoved {
            TimeSheetDataFields.timeSheetTaskType = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetTaskType")
        }
        if !TimeSheetDataFields.timeSheetTaskLevel.isRemoved {
            TimeSheetDataFields.timeSheetTaskLevel = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetTaskLevel")
        }
        if !TimeSheetDataFields.timeSheetTaskComponent.isRemoved {
            TimeSheetDataFields.timeSheetTaskComponent = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetTaskComponent")
        }
        if !TimeSheetDataFields.timeSheetNote.isRemoved {
            TimeSheetDataFields.timeSheetNote = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetNote")
        }
        if !TimeSheetDataFields.recordedHours.isRemoved {
            TimeSheetDataFields.recordedHours = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "RecordedHours")
        }
        if !TimeSheetDataFields.recordedQuantity.isRemoved {
            TimeSheetDataFields.recordedQuantity = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "RecordedQuantity")
        }
        if !TimeSheetDataFields.hoursUnitOfMeasure.isRemoved {
            TimeSheetDataFields.hoursUnitOfMeasure = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "HoursUnitOfMeasure")
        }
        if !TimeSheetDataFields.rejectionReason.isRemoved {
            TimeSheetDataFields.rejectionReason = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "RejectionReason")
        }
        if !TimeSheetEntry.timeSheetDataFields.isRemoved {
            TimeSheetEntry.timeSheetDataFields = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetDataFields")
        }
        if !TimeSheetEntry.personWorkAgreementExternalID.isRemoved {
            TimeSheetEntry.personWorkAgreementExternalID = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "PersonWorkAgreementExternalID")
        }
        if !TimeSheetEntry.companyCode.isRemoved {
            TimeSheetEntry.companyCode = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "CompanyCode")
        }
        if !TimeSheetEntry.timeSheetRecord.isRemoved {
            TimeSheetEntry.timeSheetRecord = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetRecord")
        }
        if !TimeSheetEntry.personWorkAgreement.isRemoved {
            TimeSheetEntry.personWorkAgreement = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "PersonWorkAgreement")
        }
        if !TimeSheetEntry.timeSheetDate.isRemoved {
            TimeSheetEntry.timeSheetDate = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetDate")
        }
        if !TimeSheetEntry.timeSheetIsReleasedOnSave.isRemoved {
            TimeSheetEntry.timeSheetIsReleasedOnSave = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetIsReleasedOnSave")
        }
        if !TimeSheetEntry.timeSheetPredecessorRecord.isRemoved {
            TimeSheetEntry.timeSheetPredecessorRecord = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetPredecessorRecord")
        }
        if !TimeSheetEntry.timeSheetStatus.isRemoved {
            TimeSheetEntry.timeSheetStatus = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetStatus")
        }
        if !TimeSheetEntry.timeSheetIsExecutedInTestRun.isRemoved {
            TimeSheetEntry.timeSheetIsExecutedInTestRun = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetIsExecutedInTestRun")
        }
        if !TimeSheetEntry.timeSheetOperation.isRemoved {
            TimeSheetEntry.timeSheetOperation = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetOperation")
        }
        if !TimeSheetEntry.yy1EndTimeTIM.isRemoved {
            TimeSheetEntry.yy1EndTimeTIM = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_EndTime_TIM")
        }
        if !TimeSheetEntry.yy1StartTimeTIM.isRemoved {
            TimeSheetEntry.yy1StartTimeTIM = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_StartTime_TIM")
        }
        if !TimeSheetEntry.yy1EndTimeTIMF.isRemoved {
            TimeSheetEntry.yy1EndTimeTIMF = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_EndTime_TIMF")
        }
        if !TimeSheetEntry.yy1StartTimeTIMF.isRemoved {
            TimeSheetEntry.yy1StartTimeTIMF = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_StartTime_TIMF")
        }
    }
}
