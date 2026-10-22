import AccountModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.List.Presenter {

    struct Default:
        Invitation.List.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Invitation.Router.Routes

        func renderListPage(
            model: Invitation.List.Model,
            isAdded: Bool,
            isEdited: Bool,
            isRemoved: Bool,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            if let error {
                let page = try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "User invitations",
                    content: AdminStatusView(
                        state: .init(
                            title: "Unable to load user invitations",
                            message: error
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
                return HTMLResponse(
                    content: page.content,
                    status: .internalServerError
                )
            }

            let granted = AdminListActions(
                Set(permissions.map { PermissionKey($0) })
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User invitations",
                content: AccountInvitationTable(
                    routes: routes,
                    state: .init(
                        isAdded: isAdded,
                        isEdited: isEdited,
                        isRemoved: isRemoved,
                        canAccess: granted.allows(
                            Invitation.Permissions.list
                        ),
                        permissions: granted,
                        invitations: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search ?? ""
                    )
                )
            )
        }
    }
}
