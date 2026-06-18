import Foundation

struct AdminEditUserAccountModel: Sendable {
    let id: String
    let email: String
    let password: String?
    let roleIds: [String]

    var payload: UserAccountFormPayloadModel {
        .init(email: email, password: password, roleIds: roleIds)
    }
}
