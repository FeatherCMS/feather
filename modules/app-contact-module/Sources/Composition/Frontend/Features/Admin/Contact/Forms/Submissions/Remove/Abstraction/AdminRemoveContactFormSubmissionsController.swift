import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormSubmissionsController: Sendable {

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func removeSelected(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveContactFormSubmissionsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            ContactAdminRoutes.formSubmissionRemoveSelectedRoute,
            use: removeSelected
        )
    }
}
