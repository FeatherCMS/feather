import AccountContracts
import FeatherAdmin
import Hummingbird

struct AdminListAccountInvitationDefaultController:
    AdminListAccountInvitationController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListAccountInvitationInteractor,
            presenter: any AdminListAccountInvitationPresenter
        )

    func getAccountInvitations(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let permissionScope = AccountPermissions.Invitations.list
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

    func getAccountInvitationsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let selectedIds = request.queryStrings("ids")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminListRemoveRedirect.location(
                        path: "/admin/account/invitations/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return try await runtime.presenter
            .renderRemovePage(
                page: page,
                search: search,
                items: selectedIds.map { .init(id: $0, label: $0) }
            )
            .response(from: request, context: context)
    }

    func postAccountInvitationsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: AccountAdminRoutes.invitations.description,
                        title: "Expired",
                        message:
                            "This form has expired. Please reload the page."
                    )
                ]
            )
        }
        let payload = nonceRequest.input
        let runtime = buildRuntime(request, context)
        if !payload.normalizedIds.isEmpty {
            try await runtime.interactor.remove(
                ids: payload.normalizedIds
            )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: AccountAdminRoutes.invitations.description,
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedIds.isEmpty
                        ? "User invitation removed successfully." : nil
                )
            ]
        )
    }
}
