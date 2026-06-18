import AdminOpenAPI
import Foundation

struct AdminGetUserAccountModel: Sendable {
    let id: String
    let email: String
    let roleIds: [String]
    let roleNames: [String]
    let sessions: [Components.Schemas.UserAuthSessionListItemSchema]

    init(
        details: UserAccountDetailsModel,
        roleNames: [String] = [],
        sessions: [Components.Schemas.UserAuthSessionListItemSchema] = []
    ) {
        self.id = details.id
        self.email = details.email
        self.roleIds = details.roleIds
        self.roleNames = roleNames
        self.sessions = sessions
    }
}
