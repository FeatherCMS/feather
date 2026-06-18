import Hummingbird

struct AdminGetAuthMagicLinkDefaultController: AdminGetAuthMagicLinkController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetAuthMagicLinkInteractor,
            presenter: any AdminGetAuthMagicLinkPresenter
        )

    func getAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(
            request,
            context
        )
        let permissions = context.currentUserPermissions
        do {
            let link = try await interactor.execute(
                entity: .init(id: id)
            )
            return presenter.renderPage(
                link: link,
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
}
