import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderPage(
            item: ContactModule.Form.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact form emails",
                content: SubmissionMail.List.Table(
                    state: .init(
                        id: item.key,
                        mails: item.mails,
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        breadcrumb: routes.formEmailsBreadcrumb(item.key),
                        error: error,
                        routes: routes
                    )
                )
            )
        }

    }
}
