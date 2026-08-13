import FeatherAdmin
import Foundation

struct AdminAddUserRoleModel: Sendable {
    let id: String
    let name: String
    let notes: String

    var payload: UserRoleFormPayloadModel {
        .init(id: id, name: name, notes: notes)
    }
}
