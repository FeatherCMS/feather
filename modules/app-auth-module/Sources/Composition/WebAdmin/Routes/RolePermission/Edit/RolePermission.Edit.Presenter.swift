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
    enum Presenter {}
}

extension RolePermission.Edit.Presenter {
    protocol Interface: Sendable {

        func deniedPage(
            permissions: Set<String>,
            message: String
        ) async throws -> HTMLResponse

        func renderPage(
            state: RolePermission.Edit.State,
            permissions: Set<String>,
            search: String
        ) async throws -> HTMLResponse

        func format(error: RolePermission.Edit.Error) -> String
    }
}
