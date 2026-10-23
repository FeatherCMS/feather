import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Edit {
    enum Controller {}
}

extension Profile.Edit.Controller {

    protocol Interface: Sendable {

        func getEditProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
