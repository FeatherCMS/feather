import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.List.Controller {

    struct Default:
        Invitation.List.Controller.Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Invitation.List.Interactor.Interface,
                any Invitation.List.Presenter.Interface
            >

        func getAccountInvitations(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let permissions = context.currentUserPermissions
            let permissionScope = Invitation.Permissions.list
            do {
                let canAccess = context.isCurrentUserAllowed(
                    to: permissionScope
                )
                let page = request.queryPage()
                let pageSize = 20
                let search = request.querySearch()
                let result =
                    canAccess
                    ? try await runtime.interactor.execute(
                        page: page,
                        size: pageSize,
                        search: search
                    )
                    : (
                        items: [],
                        total: 0,
                        page: page,
                        size: pageSize
                    )
                return try await runtime.presenter.renderListPage(
                    model: .init(
                        items: result.items,
                        total: result.total,
                        page: result.page,
                        pageSize: result.size
                    ),
                    isAdded: request.hasQueryFlag("added"),
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    permissions: permissions,
                    search: search,
                    error: nil
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderListPage(
                    model: .init(
                        items: [],
                        total: 0,
                        page: request.queryPage(),
                        pageSize: 20
                    ),
                    isAdded: request.hasQueryFlag("added"),
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    permissions: permissions,
                    search: request.querySearch(),
                    error: error.errorDescription
                )
            }
        }
    }
}
