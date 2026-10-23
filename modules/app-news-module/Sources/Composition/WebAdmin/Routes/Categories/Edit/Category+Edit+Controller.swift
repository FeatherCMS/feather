import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Edit {
    enum Controller {}
}

extension Category.Edit.Controller {
    protocol Interface: Sendable {
        func getEditNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
