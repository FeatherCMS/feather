import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                Category.List.Runtime

        func getCategories(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let page = request.queryPage()
            let search = request.querySearch() ?? ""
            let status = request.queryString("status")
                .flatMap(AdminMetadataStatus.init(rawValue:))
            guard context.isCurrentUserAllowed(to: Category.Permissions.list)
            else {
                return try await runtime.presenter.renderList(
                    model: .init(
                        items: [],
                        total: 0,
                        page: page,
                        pageSize: context.accountSettings.pageSize
                    ),
                    search: search,
                    status: status,
                    error: nil
                )
            }
            do {
                return try await runtime.presenter.renderList(
                    model: try await runtime.interactor.search(
                        page: page,
                        search: search.emptyToNil,
                        status: status?.rawValue
                    ),
                    search: search,
                    status: status,
                    error: nil
                )
            }
            catch {
                return try await runtime.presenter.renderList(
                    model: .init(
                        items: [],
                        total: 0,
                        page: page,
                        pageSize: context.accountSettings.pageSize
                    ),
                    search: search,
                    status: status,
                    error: error.displayMessage
                )
            }
        }
    }
}
