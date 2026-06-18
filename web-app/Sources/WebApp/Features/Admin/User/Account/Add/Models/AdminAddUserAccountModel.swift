import Foundation

struct AdminAddUserAccountModel: Sendable {
    let email: String
    let password: String

    var payload: UserAccountFormPayloadModel {
        .init(email: email, password: password, roleIds: [])
    }
}
