import HTML
import Hummingbird

struct AdminRemoveAuthMagicLinkDefaultController:
    AdminRemoveAuthMagicLinkController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveAuthMagicLinkInteractor,
            presenter: any AdminRemoveAuthMagicLinkPresenter
        )

    func getRemoveAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let link = try await interactor.get(id: id)
            return presenter.renderPage(
                id: id,
                email: link.email,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                id: id,
                error: error,
                permissions: permissions
            )
        }
    }

    func postRemoveAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            try await interactor.execute(
                entity: .init(id: id)
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/magic-links/",
                        title: "Removed",
                        message: "User magic link removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try presenter.renderError(
                    id: id,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
