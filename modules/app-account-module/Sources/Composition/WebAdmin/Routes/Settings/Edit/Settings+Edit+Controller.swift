import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit {
    enum Controller {}
}

extension Settings.Edit.Controller {

    protocol Interface: Sendable {

        func getEditSettings(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditSettings(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
