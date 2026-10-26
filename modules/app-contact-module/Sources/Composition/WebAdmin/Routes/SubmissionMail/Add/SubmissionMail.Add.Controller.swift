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

extension SubmissionMail.Add {
    enum Controller {}
}

extension SubmissionMail.Add.Controller {
    protocol Interface: Sendable {
        func add(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        func create(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
    }
}

