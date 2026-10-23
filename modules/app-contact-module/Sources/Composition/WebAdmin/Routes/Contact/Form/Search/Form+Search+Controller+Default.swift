import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Form.Search.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Form.Search.Interactor.Interface,
                any Form.Search.Presenter.Interface
            >

        func search(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let search = request.querySearch() ?? ""
            do {
                let result = try await interactor.search(
                    page: request.queryPage(),
                    search: search
                )
                return try await presenter.renderSearch(
                    items: result.items,
                    total: result.total,
                    search: search,
                    isPicker: request.hasQueryFlag("picker"),
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await presenter.renderSearch(
                    items: [],
                    total: 0,
                    search: search,
                    isPicker: request.hasQueryFlag("picker"),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }
    }
}
