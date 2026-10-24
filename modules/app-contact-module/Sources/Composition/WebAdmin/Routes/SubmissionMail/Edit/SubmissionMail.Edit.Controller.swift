import ContactApplication
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

extension SubmissionMail.Edit {
    enum Controller {}
}

extension SubmissionMail.Edit.Controller {
    protocol Interface: Sendable {
        func edit(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        func update(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
    }
}

extension SubmissionMail.Edit.Controller.Interface {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: SubmissionMail.Router.Routes
    ) {
        router.get(routes.formEmailEdit.routerPath, use: edit)
        router.post(routes.formEmailEdit.routerPath, use: update)
    }
}
