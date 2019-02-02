import SAPOfflineOData
import SAPFoundation
import SAPCommon

class UserRepositoryImpl: UserRepository {
    
    private static let usernameKey = "username"
    
    private var sapUrlSession: SAPURLSession
    
    public enum UserRepositoryException: Error {
        case UserNameIsNotAvailableException
    }
    
    init(sapUrlSession: SAPURLSession){
        self.sapUrlSession = sapUrlSession
    }
    
    func fetchUsername() throws -> String {
        let userRoles = createUserRolesAccessInstance()
        
        var roleInfo: SAPcpmsUserRoles.SAPcpmsUserInfo?
        var error: Error?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        userRoles.load() { roleInfoResult, errorResult in
            roleInfo = roleInfoResult
            error = errorResult
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        return try handleUserRoleLoadingResult(roleInfo: roleInfo, error: error)
    }
    
    private func createUserRolesAccessInstance() -> SAPcpmsUserRoles {
        let settingsParameters = SAPcpmsSettingsParameters(backendURL: ServiceConfiguration.getHostUrl(), applicationID: ServiceConfiguration.getScpAppId())
        
        return SAPcpmsUserRoles(sapURLSession: sapUrlSession, settingsParameters: settingsParameters)
    }
    
    private func handleUserRoleLoadingResult(roleInfo: SAPcpmsUserRoles.SAPcpmsUserInfo?, error: Error?) throws -> String {
        if let error = error {
            if let username = tryToGetUserNameFromCache() {
                return username
            }
            
            throw error
        }
        
        if let name = roleInfo?.userName {
            cacheUserName(userName: name)
            
            return name
        }
        else {
            throw UserRepositoryException.UserNameIsNotAvailableException
        }
    }
    
    private func cacheUserName(userName: String) {
        UserDefaults.standard.set(userName, forKey: UserRepositoryImpl.usernameKey)
    }
    
    private func tryToGetUserNameFromCache() -> String? {
        return UserDefaults.standard.value(forKey: UserRepositoryImpl.usernameKey) as? String
    }
    
}
