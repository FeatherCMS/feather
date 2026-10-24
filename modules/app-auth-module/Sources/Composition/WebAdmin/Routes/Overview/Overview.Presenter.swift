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

extension Overview {
    enum Presenter {}
}

extension Overview.Presenter {
    protocol Interface: Sendable {

        func renderOverview(
            model: Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
