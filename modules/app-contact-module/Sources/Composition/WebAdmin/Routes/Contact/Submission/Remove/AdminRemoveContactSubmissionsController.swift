import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

protocol AdminRemoveContactSubmissionsController: Sendable {

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveContactSubmissionsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(ContactAdminRoutes.submissionRemove, use: remove)
    }
}
