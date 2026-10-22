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

extension Email.View {
    enum Interactor {}
}

extension Email.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Email.View.Model
        ) async throws -> Email.View.Detail
    }
}
