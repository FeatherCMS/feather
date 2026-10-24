import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension RolePermission.Edit {
    struct Pair: Hashable, Sendable {
        let roleId: String
        let permissionId: String

        var encoded: String { "\(roleId)|\(permissionId)" }

        init(roleId: String, permissionId: String) {
            self.roleId = roleId
            self.permissionId = permissionId
        }

        init?(encoded: String) {
            let pieces = encoded.split(separator: "|", maxSplits: 1)
                .map(String.init)
            guard pieces.count == 2, !pieces[0].isEmpty, !pieces[1].isEmpty
            else {
                return nil
            }
            self.roleId = pieces[0]
            self.permissionId = pieces[1]
        }
    }
}
