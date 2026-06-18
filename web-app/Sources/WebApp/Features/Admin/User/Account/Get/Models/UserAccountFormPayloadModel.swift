import Foundation

struct UserAccountFormPayloadModel: Sendable {
    let email: String
    let password: String?
    let roleIds: [String]
}
