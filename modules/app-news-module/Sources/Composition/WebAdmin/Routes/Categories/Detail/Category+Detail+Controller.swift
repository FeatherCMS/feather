import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Detail {
    enum Controller {}
}

extension Category.Detail.Controller {
    protocol Interface: Sendable {
        func getNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
