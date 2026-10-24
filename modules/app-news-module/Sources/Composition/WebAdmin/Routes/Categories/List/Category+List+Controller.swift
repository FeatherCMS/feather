import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Category.List {
    enum Controller {}
}

extension Category.List.Controller {
    protocol Interface: Sendable {
        func getCategories(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
