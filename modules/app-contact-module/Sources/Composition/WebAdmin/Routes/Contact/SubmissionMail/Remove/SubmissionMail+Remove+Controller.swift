import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Remove {
    enum Controller {}
}

extension SubmissionMail.Remove.Controller {
    protocol Interface: Sendable {

        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}

extension SubmissionMail.Remove.Controller.Interface {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Contact.Router.Routes
    ) {
        router.post(
            routes.formEmailRemove.routerPath,
            use: remove
        )
    }
}
