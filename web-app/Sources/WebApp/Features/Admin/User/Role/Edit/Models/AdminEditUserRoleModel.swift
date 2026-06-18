import Foundation

struct AdminEditUserRoleModel: Sendable {
    let id: String
    let name: String
    let notes: String

    var payload: UserRoleFormPayloadModel {
        .init(name: name, notes: notes)
    }
}
