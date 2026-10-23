import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Form.Search.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderSearch(
            items: [Form.Search.Model.Item],
            total: Int,
            search: String,
            isPicker: Bool,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            let page = request.queryPage()
            let pageSize = Form.Search.Model.pageSize
            let pageState = AdminListPageState(
                page: page,
                pageSize: pageSize,
                total: total
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact forms",
                content: ContactFormTable(
                    state: .init(
                        items: items,
                        pageState: pageState,
                        search: search,
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        isPicker: isPicker,
                        routes: routes
                    )
                )
            )
        }
    }
}
