import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminViewNewsCategoryDefaultController:
    AdminViewNewsCategoryController
{
    let buildRuntime: AdminNewsCategoryRuntimeBuilder

    func getNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        do {
            let item = try await runtime.interactor.get(
                id: context.requiredID()
            )
            return try await runtime.presenter.renderDetails(item: item)
        }
        catch {
            return try await runtime.presenter.renderError(
                error.displayMessage
            )
        }
    }
}
