import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Detail.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderDetailsPage(
            formId: String,
            item: Submission.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact form submission",
                content: Submission.Detail.DetailsView(
                    state: .init(
                        formId: formId,
                        item: item,
                        error: error,
                        breadcrumb: routes.formSubmissionsBreadcrumb(formId),
                        routes: routes,
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        )
                    )
                )
            )
        }
    }
}
