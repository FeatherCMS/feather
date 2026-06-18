import Foundation

struct UserAccountDetailsModel: Sendable {
    let id: String
    let email: String
    let roleIds: [String]
}
