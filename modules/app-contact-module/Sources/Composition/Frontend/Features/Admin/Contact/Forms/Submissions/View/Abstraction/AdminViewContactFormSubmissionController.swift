import FeatherAdmin
import Hummingbird

protocol AdminViewContactFormSubmissionController: Sendable {
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}

extension AdminViewContactFormSubmissionController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            ContactAdminRoutes.formSubmissionDetailsRoute,
            use: get
        )
    }
}
