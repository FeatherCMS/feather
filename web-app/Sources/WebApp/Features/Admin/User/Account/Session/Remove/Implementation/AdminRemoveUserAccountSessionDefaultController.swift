import HTML
import Hummingbird

struct AdminRemoveUserAccountSessionDefaultController:
    AdminRemoveUserAccountSessionController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveUserAccountSessionInteractor,
            presenter: any AdminRemoveUserAccountSessionPresenter
        )

    func getRemoveUserAccountSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let accountId = try context.requiredID()
        let sessionId = try context.requiredParameter("sessionId")

        do {
            let session = try await interactor.get(
                accountId: accountId,
                sessionId: sessionId
            )
            return presenter.renderPage(
                state: .init(
                    model: session,
                    breadcrumb: presenter.breadcrumb(
                        accountId: accountId,
                        sessionId: sessionId
                    )
                ),
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.errorPage(
                accountId: accountId,
                sessionId: sessionId,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postRemoveUserAccountSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let accountId = try context.requiredID()
        let sessionId = try context.requiredParameter("sessionId")

        do {
            try await interactor.execute(
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
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/accounts/\(accountId)/",
                        title: "Removed",
                        message: "Session removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try presenter.errorPage(
                    accountId: accountId,
                    sessionId: sessionId,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
