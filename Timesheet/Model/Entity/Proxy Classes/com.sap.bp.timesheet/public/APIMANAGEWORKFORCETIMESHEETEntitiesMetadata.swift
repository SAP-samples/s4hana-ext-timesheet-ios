//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

public class APIMANAGEWORKFORCETIMESHEETEntitiesMetadata {
    public static var document: CSDLDocument = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.resolve()

    private static func resolve() -> CSDLDocument {
        try! APIMANAGEWORKFORCETIMESHEETEntitiesFactory.registerAll()
        APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.parsed.hasGeneratedProxies = true
        return APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.parsed
    }

    public class ComplexTypes {
        public static var timeSheetDataFields: ComplexType = APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.parsed.complexType(withName: "API_MANAGE_WORKFORCE_TIMESHEET.TimeSheetDataFields")
    }

    public class EntityTypes {
        public static var timeSheetEntry: EntityType = APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.parsed.entityType(withName: "API_MANAGE_WORKFORCE_TIMESHEET.TimeSheetEntry")
    }

    public class EntitySets {
        public static var timeSheetEntryCollection: EntitySet = APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.parsed.entitySet(withName: "TimeSheetEntryCollection")
    }
}
