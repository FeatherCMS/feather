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

extension Email.Remove {
    enum Interactor {}
}

extension Email.Remove.Interactor {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Email.View.Detail

        func execute(
            entity: Email.Remove.Model
        ) async throws

        func remove(
            ids: [String]
        ) async throws
    }
}
