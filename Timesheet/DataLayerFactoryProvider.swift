import SAPFoundation
import SAPCommon
import SAPOData

class DataLayerFactoryProvider {
    
    public static private(set) var shared: DataLayerFactory!
    
    public static func initSharedInstance(sapUrlSession: SAPURLSession) {
        let factory = DataLayerBackendFactory(sapUrlSession: sapUrlSession)
        shared = factory
    }
    
    private init() {
        
    }
    
}
