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

        func render(
            model: Submission.Search.Model,
            search: String,
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
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        breadcrumb: ContactAdminRoutes.breadcrumb,
                        error: error
                    )
                )
            )
        }
    }
}
