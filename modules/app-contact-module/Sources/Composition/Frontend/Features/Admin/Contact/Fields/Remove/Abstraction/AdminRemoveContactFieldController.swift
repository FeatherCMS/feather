import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFieldController: Sendable {

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func removeSelected(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveContactFieldController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(ContactAdminRoutes.fieldRemove, use: removeSelected)
    }
}
