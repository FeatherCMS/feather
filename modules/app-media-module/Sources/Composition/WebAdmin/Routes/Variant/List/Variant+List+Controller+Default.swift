import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.List.Controller {
    struct Default: Variant.List.Controller.Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Variant.List.Interactor.Interface,
                any Variant.List.Presenter.Interface
            >

        func getMediaVariants(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            guard context.isCurrentUserAllowed(to: Variant.Permissions.list)
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            do {
                return try await presenter.renderListPage(
                    model: try await interactor.listMediaVariants(
                        page: request.queryPage(),
                        search: request.querySearch()
                    ),
                    permissions: context.currentUserAdminListActions,
                    search: request.querySearch()
                )
            }
            catch let error as Variant.List.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
