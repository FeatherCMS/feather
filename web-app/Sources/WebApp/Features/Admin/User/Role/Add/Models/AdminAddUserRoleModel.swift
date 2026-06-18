import Foundation

struct AdminAddUserRoleModel: Sendable {
    let name: String
    let notes: String

    var payload: UserRoleFormPayloadModel {
        .init(name: name, notes: notes)
    }
}
