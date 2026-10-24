import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Detail {
    enum Presenter {}
}

extension Invitation.Detail.Presenter {

    protocol Interface: Sendable {

        func renderDetailsPage(
            invitation: Invitation.Detail.Result,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
