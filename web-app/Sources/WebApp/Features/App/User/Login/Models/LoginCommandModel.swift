import Foundation

struct LoginCommandModel: Sendable {
    let email: String
    let password: String
    let isPersistent: Bool
}
