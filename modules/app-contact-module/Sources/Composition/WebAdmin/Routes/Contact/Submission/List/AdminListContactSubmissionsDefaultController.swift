import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

struct AdminListContactSubmissionsDefaultController:
    AdminListContactSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminListContactSubmissionsInteractor,
            any AdminListContactSubmissionsPresenter
        >
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let search = request.querySearch() ?? ""
        do {
            let items = try await interactor.list()
                .filter {
                    search.isEmpty
                        || $0.formName.localizedCaseInsensitiveContains(search)
                        || $0.status.localizedCaseInsensitiveContains(search)
                        || $0.createdAt.localizedCaseInsensitiveContains(search)
                }
            return try await presenter.render(
                items: items,
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.render(
                items: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

}
