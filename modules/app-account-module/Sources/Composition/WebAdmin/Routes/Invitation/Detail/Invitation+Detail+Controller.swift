import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Detail {
    enum Controller {}
}

extension Invitation.Detail.Controller {

    protocol Interface: Sendable {

        func getDetail(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
