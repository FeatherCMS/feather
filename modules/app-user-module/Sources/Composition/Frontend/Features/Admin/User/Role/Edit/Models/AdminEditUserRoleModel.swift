import FeatherAdmin
import Foundation

struct AdminEditUserRoleModel: Sendable {
    let id: String
    let name: String
    let notes: String

    var payload: UserRoleFormPayloadModel {
        .init(id: id, name: name, notes: notes)
    }
}
