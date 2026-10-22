import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

protocol AdminRemoveNewsCategoryController: Sendable {
    func postRemoveNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
    }
}
