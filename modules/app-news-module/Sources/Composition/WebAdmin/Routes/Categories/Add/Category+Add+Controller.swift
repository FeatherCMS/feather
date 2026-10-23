import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Category.Add {
    enum Controller {}
}

extension Category.Add.Controller {
    protocol Interface: Sendable {
        func getAddCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
