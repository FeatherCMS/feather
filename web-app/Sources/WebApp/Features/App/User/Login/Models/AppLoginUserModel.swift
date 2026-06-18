import Foundation

struct AppLoginUserModel: Sendable {
    let email: String
    let password: String
    let isPersistent: Bool

    var command: LoginCommandModel {
        .init(email: email, password: password, isPersistent: isPersistent)
    }
}
