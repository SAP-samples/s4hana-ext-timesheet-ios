import Foundation

protocol UserRepository {
    
    func fetchUsername() throws -> String
    
}
