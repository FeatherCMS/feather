import Foundation

struct AdminGetAuthProfileModel: Sendable {
    let id: String
    let email: String
    let roles: [String]
    let permissions: [String]

    init(account: AccountModel) {
        self.id = account.user.id
        self.email = account.user.email
        self.roles = account.roles
        self.permissions = account.permissions
    }
}
