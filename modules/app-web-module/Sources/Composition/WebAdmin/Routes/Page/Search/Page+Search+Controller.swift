import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page {
    enum Search {}
}

extension Page.Search {
    enum Controller {}
}

extension Page.Search.Controller {
    protocol Interface: Sendable {

        func getSearchPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postPageStatus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
