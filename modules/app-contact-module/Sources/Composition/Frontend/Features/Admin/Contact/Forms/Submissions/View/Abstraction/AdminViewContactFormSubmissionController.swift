import FeatherAdmin
import Hummingbird

protocol AdminViewContactFormSubmissionController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminViewContactFormSubmissionController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            ContactAdminRoutes.formSubmissionDetailsRoute,
            use: get
        )
    }
}
