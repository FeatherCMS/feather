import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.Remove {
    enum Controller {}
}

extension WebDomain.Menu.Remove.Controller {
    protocol Interface: Sendable {

    func postRemoveMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    }
}
