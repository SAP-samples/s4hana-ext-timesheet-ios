//# xsc 17.12.4-8c3504-20180321

import Foundation
import SAPOData

open class APIMANAGEWORKFORCETIMESHEETEntities<Provider: DataServiceProvider>: DataService<Provider> {
    public override init(provider: Provider) {
        super.init(provider: provider)
        self.provider.metadata = APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.document
    }

    open func fetchTimeSheetEntry(matching query: DataQuery) throws -> TimeSheetEntry {
        return try CastRequired<TimeSheetEntry>.from(self.executeQuery(query.fromDefault(APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntitySets.timeSheetEntryCollection)).requiredEntity())
    }

    open func fetchTimeSheetEntry(matching query: DataQuery, completionHandler: @escaping (TimeSheetEntry?, Error?) -> Void) -> Void {
        self.addBackgroundOperation {
        do {
            let result: TimeSheetEntry = try self.fetchTimeSheetEntry(matching: query)
            self.completionQueue.addOperation {
                completionHandler(result, nil)
            }
        }
        catch let error {
            self.completionQueue.addOperation {
                completionHandler(nil, error)
            }
        }
        }
    }

    open func fetchTimeSheetEntryCollection(matching query: DataQuery = DataQuery()) throws -> Array<TimeSheetEntry> {
        return try TimeSheetEntry.array(from: self.executeQuery(query.fromDefault(APIMANAGEWORKFORCETIMESHEETEntitiesMetadata.EntitySets.timeSheetEntryCollection)).entityList())
    }

    open func fetchTimeSheetEntryCollection(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<TimeSheetEntry>?, Error?) -> Void) -> Void {
        self.addBackgroundOperation {
        do {
            let result: Array<TimeSheetEntry> = try self.fetchTimeSheetEntryCollection(matching: query)
            self.completionQueue.addOperation {
                completionHandler(result, nil)
            }
        }
        catch let error {
            self.completionQueue.addOperation {
                completionHandler(nil, error)
            }
        }
        }
    }

    override open func refreshMetadata() throws -> Void {
        objc_sync_enter(self)
        defer { objc_sync_exit(self); }
        do {
            try ProxyInternal.refreshMetadata(service: self, fetcher: nil, options: APIMANAGEWORKFORCETIMESHEETEntitiesMetadataParser.options)
            APIMANAGEWORKFORCETIMESHEETEntitiesMetadataChanges.merge(metadata: self.metadata)
        }
    }

    @available(swift, deprecated: 4.0, renamed: "fetchTimeSheetEntryCollection")
    open func timeSheetEntryCollection(query: DataQuery = DataQuery()) throws -> Array<TimeSheetEntry> {
        return try self.fetchTimeSheetEntryCollection(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchTimeSheetEntryCollection")
    open func timeSheetEntryCollection(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<TimeSheetEntry>?, Error?) -> Void) -> Void {
        self.fetchTimeSheetEntryCollection(matching: query, completionHandler: completionHandler)
    }
}
