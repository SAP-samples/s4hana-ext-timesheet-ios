//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

open class TimeSheetDataFields: ComplexValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var controllingArea: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "ControllingArea")

    public static var senderCostCenter: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "SenderCostCenter")

    public static var receiverCostCenter: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "ReceiverCostCenter")

    public static var internalOrder: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "InternalOrder")

    public static var activityType: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "ActivityType")

    public static var wbsElement: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "WBSElement")

    public static var workItem: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "WorkItem")

    public static var billingControlCategory: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "BillingControlCategory")

    public static var purchaseOrder: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "PurchaseOrder")

    public static var purchaseOrderItem: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "PurchaseOrderItem")

    public static var timeSheetTaskType: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetTaskType")

    public static var timeSheetTaskLevel: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetTaskLevel")

    public static var timeSheetTaskComponent: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetTaskComponent")

    public static var timeSheetNote: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "TimeSheetNote")

    public static var recordedHours: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "RecordedHours")

    public static var recordedQuantity: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "RecordedQuantity")

    public static var hoursUnitOfMeasure: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "HoursUnitOfMeasure")

    public static var rejectionReason: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.property(withName: "RejectionReason")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields)
    }

    open var activityType: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.activityType))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.activityType, to: StringValue.of(optional: value))
        }
    }

    open var billingControlCategory: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.billingControlCategory))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.billingControlCategory, to: StringValue.of(optional: value))
        }
    }

    open var controllingArea: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.controllingArea))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.controllingArea, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> TimeSheetDataFields {
        return CastRequired<TimeSheetDataFields>.from(self.copyComplex())
    }

    open var hoursUnitOfMeasure: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.hoursUnitOfMeasure))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.hoursUnitOfMeasure, to: StringValue.of(optional: value))
        }
    }

    open var internalOrder: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.internalOrder))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.internalOrder, to: StringValue.of(optional: value))
        }
    }

    override open var isProxy: Bool {
        get {
            return true
        }
    }

    open var old: TimeSheetDataFields {
        get {
            return CastRequired<TimeSheetDataFields>.from(self.oldComplex)
        }
    }

    open var purchaseOrder: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.purchaseOrder))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.purchaseOrder, to: StringValue.of(optional: value))
        }
    }

    open var purchaseOrderItem: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.purchaseOrderItem))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.purchaseOrderItem, to: StringValue.of(optional: value))
        }
    }

    open var receiverCostCenter: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.receiverCostCenter))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.receiverCostCenter, to: StringValue.of(optional: value))
        }
    }

    open var recordedHours: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: TimeSheetDataFields.recordedHours))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.recordedHours, to: DecimalValue.of(optional: value))
        }
    }

    open var recordedQuantity: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: TimeSheetDataFields.recordedQuantity))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.recordedQuantity, to: DecimalValue.of(optional: value))
        }
    }

    open var rejectionReason: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.rejectionReason))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.rejectionReason, to: StringValue.of(optional: value))
        }
    }

    open var senderCostCenter: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.senderCostCenter))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.senderCostCenter, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetNote: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.timeSheetNote))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.timeSheetNote, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetTaskComponent: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.timeSheetTaskComponent))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.timeSheetTaskComponent, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetTaskLevel: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.timeSheetTaskLevel))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.timeSheetTaskLevel, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetTaskType: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.timeSheetTaskType))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.timeSheetTaskType, to: StringValue.of(optional: value))
        }
    }

    open var wbsElement: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.wbsElement))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.wbsElement, to: StringValue.of(optional: value))
        }
    }

    open var workItem: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetDataFields.workItem))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetDataFields.workItem, to: StringValue.of(optional: value))
        }
    }
}
