import HTML
import Hummingbird

struct AdminGetWebMenuDefaultController: AdminGetWebMenuController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetWebMenuInteractor,
            presenter: any AdminGetWebMenuPresenter
        )

    func getWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let rule = try await runtime.interactor.execute(
                entity: .init(
                    id: id,
                    isAdded: request.hasQueryFlag("added"),
                    isRemoved: request.hasQueryFlag("removed")
                )
            )
            return runtime.presenter.renderDetailsPage(
                rule: rule,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions,
                isAdded: request.hasQueryFlag("added"),
                isRemoved: request.hasQueryFlag("removed")
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
    }
}
