import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Search.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Submission.Search.Interactor.Interface,
                any Submission.Search.Presenter.Interface
            >

        func list(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let search = request.querySearch() ?? ""
            do {
                let model = try await runtime.interactor.search(
                    page: request.queryPage(),
                    search: search.isEmpty ? nil : search
                )
                return try await runtime.presenter.render(
                    model: model,
                    search: search,
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await runtime.presenter.render(
                    model: .init(items: [], total: 0),
                    search: search,
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }
    }
}
