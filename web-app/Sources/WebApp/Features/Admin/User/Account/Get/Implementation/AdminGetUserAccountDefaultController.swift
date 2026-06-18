import HTML
import Hummingbird

struct AdminGetUserAccountDefaultController: AdminGetUserAccountController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetUserAccountInteractor,
            removeSessionInteractor:
                any AdminRemoveUserAccountSessionInteractor,
            presenter: any AdminGetUserAccountPresenter,
            roleRepository: AdminEditUserAccountRoleOpenAPIRepository
        )

    func getUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, _, presenter, roleRepository) = buildRuntime(
            request,
            context
        )
        let id = try context.requiredID()
        do {
            let account = try await interactor.execute(id: id)
            let roleLookup = Dictionary(
                uniqueKeysWithValues:
                    try await roleRepository.list().map { ($0.id, $0.name) }
            )
            let model = AdminGetUserAccountModel(
                details: .init(
                    id: account.id,
                    email: account.email,
                    roleIds: account.roleIds
                ),
                roleNames: account.roleIds.compactMap { roleLookup[$0] },
                sessions: account.sessions
            )
            return presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions,
                isSessionRemoved: request.hasQueryFlag("removed")
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.errorPage(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func getUserAccountSessionsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, _, presenter, _) = buildRuntime(request, context)
        let accountId = try context.requiredID()
        let selectedIds = request.queryStrings("selectedIds")
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: "/admin/user/accounts/\(accountId)/"
                ]
            )
        }
        return
            try presenter
            .renderSessionsBulkRemoveConfirmation(
                accountId: accountId,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postUserAccountSessionsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, removeSessionInteractor, _, _) = buildRuntime(
            request,
            context
        )
        let accountId = try context.requiredID()
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        for sessionId in payload.normalizedSelectedIds {
            try await removeSessionInteractor.execute(
                entity: .init(
                    accountId: accountId,
                    sessionId: sessionId,
                    accountEmail: "",
                    isPersistent: false,
                    expiresAt: 0,
                    createdAt: 0,
                    updatedAt: 0
                )
            )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location:
                    payload.normalizedSelectedIds.isEmpty
                    ? "/admin/user/accounts/\(accountId)/"
                    : AdminToastRedirect.location(
                        defaultPath: "/admin/user/accounts/\(accountId)/",
                        title: "Removed",
                        message: "Session removed successfully."
                    )
            ]
        )
    }
}
