import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Remove {
    enum Controller {}
}

extension Menu.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
