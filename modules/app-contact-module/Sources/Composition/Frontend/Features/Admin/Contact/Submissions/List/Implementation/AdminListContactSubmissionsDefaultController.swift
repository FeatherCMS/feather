import FeatherAdmin
import Foundation
import Hummingbird

struct AdminListContactSubmissionsDefaultController:
    AdminListContactSubmissionsController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminListContactSubmissionsInteractor,
            any AdminListContactSubmissionsPresenter
        >
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
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
