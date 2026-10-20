import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormEmailController: Sendable {

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveContactFormEmailController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            ContactAdminRoutes.formEmailRemoveRoute,
            use: remove
        )
    }
}
