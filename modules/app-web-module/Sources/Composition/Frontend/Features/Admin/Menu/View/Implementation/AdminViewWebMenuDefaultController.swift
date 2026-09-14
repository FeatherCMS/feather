import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenuDefaultController: AdminViewWebMenuController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewWebMenuInteractor,
            presenter: any AdminViewWebMenuPresenter
        )

    func getWebMenu(
        request: Request,
        context: DefaultRequestContext
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
            return try await runtime.presenter.renderDetailsPage(
                rule: rule,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions,
                isAdded: request.hasQueryFlag("added"),
                isRemoved: request.hasQueryFlag("removed")
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                breadcrumb: runtime.presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
    }
}
