import FeatherAdmin
import HTML
import Hummingbird

struct AdminRemoveAuthSessionDefaultController:
    AdminRemoveAuthSessionController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveAuthSessionInteractor,
            presenter: any AdminRemoveAuthSessionPresenter
        )

    func getRemoveAuthSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let identityId = try context.requiredID()
        let sessionId = try context.requiredParameter("sessionId")

        do {
            let session = try await interactor.get(
                identityId: identityId,
                sessionId: sessionId
            )
            return presenter.renderPage(
                state: .init(
                    model: session,
                    breadcrumb: presenter.breadcrumb(
                        identityId: identityId,
                        sessionId: sessionId
                    )
                ),
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.errorPage(
                identityId: identityId,
                sessionId: sessionId,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postRemoveAuthSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let identityId = try context.requiredID()
        let sessionId = try context.requiredParameter("sessionId")

        do {
            try await interactor.execute(
                entity: .init(
                    identityId: identityId,
                    sessionId: sessionId,
                    identityEmail: "",
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
                        defaultPath: "/admin/user/identities/\(identityId)/",
                        title: "Removed",
                        message: "Session removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try presenter.errorPage(
                    identityId: identityId,
                    sessionId: sessionId,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
