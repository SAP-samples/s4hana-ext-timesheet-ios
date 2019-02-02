import Foundation
@testable import Timesheet

class UserRepositoryMock: UserRepository {
    
    public var fetchUsernameResult: String!
    
    func fetchUsername() throws -> String {
        if let result = fetchUsernameResult {
            return result
        }
        // In the case, when no user name is specified, return an empty string
        return ""
    }
    
}
