import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormController: Sendable {

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveContactFormController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(ContactAdminRoutes.formRemove, use: remove)
    }
}
