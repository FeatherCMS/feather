import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Search.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func render(
            model: Submission.Search.Model,
            search: String,
            formKey: String?,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            let pageState = AdminListPageState(
                page: request.queryPage(),
                pageSize: Submission.Search.Router.pageSize,
                total: model.total
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact submissions",
                content: Submission.Search.Table(
                    state: .init(
                        items: model.items,
                        pageState: pageState,
                        search: search,
                        formKey: formKey,
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        breadcrumb: formKey.map(
                            routes.formSubmissionsBreadcrumb
                        )
                            ?? ContactAdminRoutes.breadcrumb,
                        routes: routes,
                        error: error
                    )
                )
            )
        }
    }
}
