//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

internal class APIMANAGEWORKFORCETIMESHEETEntitiesFactory {
    static func registerAll() throws -> Void {
        APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.ComplexTypes.timeSheetDataFields.registerFactory(ObjectFactory.with(create: { TimeSheetDataFields(withDefaults: false) }, createWithDecoder: { d in try TimeSheetDataFields(from: d) } ))
        APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntityTypes.timeSheetEntry.registerFactory(ObjectFactory.with(create: { TimeSheetEntry(withDefaults: false) }, createWithDecoder: { d in try TimeSheetEntry(from: d) } ))
        APIMANAGEWORKFORCETIMESHEETEntitiesStaticResolver.resolve()
    }
}
