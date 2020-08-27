//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

internal class APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser {
    internal static let options: Int = (CSDLOption.processMixedVersions | CSDLOption.retainOriginalText | CSDLOption.ignoreUndefinedTerms)

    internal static let parsed: CSDLDocument = APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.parse()

    static func parse() -> CSDLDocument {
        let parser: CSDLParser = CSDLParser()
        parser.logWarnings = false
        parser.csdlOptions = APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.options
        let metadata: CSDLDocument = parser.parseInProxy(APIMANAGEWORKFORCETIMESHEETEntitiesMetadataText.xml, url: "API_MANAGE_WORKFORCE_TIMESHEET")
        metadata.proxyVersion = "17.12.4-8c3504-20180321"
        return metadata
    }
}
