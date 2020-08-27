//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

open class TimeSheetEntry: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var timeSheetDataFields: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetDataFields")

    public static var personWorkAgreementExternalID: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "PersonWorkAgreementExternalID")

    public static var companyCode: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "CompanyCode")

    public static var timeSheetRecord: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetRecord")

    public static var personWorkAgreement: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "PersonWorkAgreement")

    public static var timeSheetDate: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetDate")

    public static var timeSheetIsReleasedOnSave: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetIsReleasedOnSave")

    public static var timeSheetPredecessorRecord: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetPredecessorRecord")

    public static var timeSheetStatus: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetStatus")

    public static var timeSheetIsExecutedInTestRun: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetIsExecutedInTestRun")

    public static var timeSheetOperation: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "TimeSheetOperation")

    public static var yy1EndTimeTIM: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_EndTime_TIM")

    public static var yy1StartTimeTIM: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_StartTime_TIM")

    public static var yy1EndTimeTIMF: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_EndTime_TIMF")

    public static var yy1StartTimeTIMF: Property = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.property(withName: "YY1_StartTime_TIMF")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry)
    }

    open class func array(from: EntityValueList) -> Array<TimeSheetEntry> {
        return ArrayConverter.convert(from.toArray(), Array<TimeSheetEntry>())
    }

    open var companyCode: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.companyCode))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.companyCode, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> TimeSheetEntry {
        return CastRequired<TimeSheetEntry>.from(self.copyEntity())
    }

    override open var isProxy: Bool {
        get {
            return true
        }
    }

    open class func key(personWorkAgreementExternalID: String?, companyCode: String?, timeSheetRecord: String?) -> EntityKey {
        return EntityKey().with(name: "PersonWorkAgreementExternalID", value: StringValue.of(optional: personWorkAgreementExternalID)).with(name: "CompanyCode", value: StringValue.of(optional: companyCode)).with(name: "TimeSheetRecord", value: StringValue.of(optional: timeSheetRecord))
    }

    open var old: TimeSheetEntry {
        get {
            return CastRequired<TimeSheetEntry>.from(self.oldEntity)
        }
    }

    open var personWorkAgreement: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.personWorkAgreement))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.personWorkAgreement, to: StringValue.of(optional: value))
        }
    }

    open var personWorkAgreementExternalID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.personWorkAgreementExternalID))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.personWorkAgreementExternalID, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetDataFields: TimeSheetDataFields? {
        get {
            return CastOptional<TimeSheetDataFields>.from(self.optionalValue(for: TimeSheetEntry.timeSheetDataFields))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetDataFields, to: value)
        }
    }

    open var timeSheetDate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: TimeSheetEntry.timeSheetDate))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetDate, to: value)
        }
    }

    open var timeSheetIsExecutedInTestRun: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: TimeSheetEntry.timeSheetIsExecutedInTestRun))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetIsExecutedInTestRun, to: BooleanValue.of(optional: value))
        }
    }

    open var timeSheetIsReleasedOnSave: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: TimeSheetEntry.timeSheetIsReleasedOnSave))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetIsReleasedOnSave, to: BooleanValue.of(optional: value))
        }
    }

    open var timeSheetOperation: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.timeSheetOperation))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetOperation, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetPredecessorRecord: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.timeSheetPredecessorRecord))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetPredecessorRecord, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetRecord: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.timeSheetRecord))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetRecord, to: StringValue.of(optional: value))
        }
    }

    open var timeSheetStatus: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TimeSheetEntry.timeSheetStatus))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.timeSheetStatus, to: StringValue.of(optional: value))
        }
    }

    open var yy1EndTimeTIM: LocalTime? {
        get {
            return LocalTime.castOptional(self.optionalValue(for: TimeSheetEntry.yy1EndTimeTIM))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.yy1EndTimeTIM, to: value)
        }
    }

    open var yy1EndTimeTIMF: Int? {
        get {
            return UnsignedByte.optional(self.optionalValue(for: TimeSheetEntry.yy1EndTimeTIMF))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.yy1EndTimeTIMF, to: UnsignedByte.of(optional: value))
        }
    }

    open var yy1StartTimeTIM: LocalTime? {
        get {
            return LocalTime.castOptional(self.optionalValue(for: TimeSheetEntry.yy1StartTimeTIM))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.yy1StartTimeTIM, to: value)
        }
    }

    open var yy1StartTimeTIMF: Int? {
        get {
            return UnsignedByte.optional(self.optionalValue(for: TimeSheetEntry.yy1StartTimeTIMF))
        }
        set(value) {
            self.setOptionalValue(for: TimeSheetEntry.yy1StartTimeTIMF, to: UnsignedByte.of(optional: value))
        }
    }
}
