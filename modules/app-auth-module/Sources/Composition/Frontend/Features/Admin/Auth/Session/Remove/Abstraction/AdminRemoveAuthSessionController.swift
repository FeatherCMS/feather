import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

protocol AdminRemoveAuthSessionController: Sendable {

    func postRemoveAuthSession(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthSessionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
    }
}
