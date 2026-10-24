import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Detail {
    enum Controller {}
}

extension Profile.Detail.Controller {

    protocol Interface: Sendable {

        func getDetail(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
