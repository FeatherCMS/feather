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

extension MagicLink.Edit {
    struct Model: Sendable {
        let id: String
        let credentialId: String
        let isPersistent: Bool

        var payload: MagicLink.Add.Payload {
            .init(credentialId: credentialId, isPersistent: isPersistent)
        }
    }
}
