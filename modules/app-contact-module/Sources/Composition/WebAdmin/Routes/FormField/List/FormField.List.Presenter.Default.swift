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

extension FormField.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: FormField.Router.Routes

        func renderList(
            fields: [FormField.Model],
            forms: [FormField.List.FormOption],
            total: Int,
            formKey: String?,
            search: String,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            let page = request.queryPage()
            let pageState = AdminListPageState(
                page: page,
                pageSize: FormField.List.Router.pageSize,
                total: total
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact form fields",
                content: FormField.List.Page(
                    state: .init(
                        fields: fields,
                        forms: forms,
                        formKey: formKey,
                        pageState: pageState,
                        search: search,
                        error: error,
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        breadcrumb: routes.fieldsBreadcrumb,
                        routes: routes
                    )
                )
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Contact form fields",
                content: AdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message:
                            "Your account cannot access contact form fields."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: .forbidden)
        }
    }
}
