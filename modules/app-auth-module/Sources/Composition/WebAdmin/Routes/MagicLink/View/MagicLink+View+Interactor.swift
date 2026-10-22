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

extension MagicLink.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: MagicLink.View.Model
        ) async throws -> MagicLink.View.Detail
    }
}
