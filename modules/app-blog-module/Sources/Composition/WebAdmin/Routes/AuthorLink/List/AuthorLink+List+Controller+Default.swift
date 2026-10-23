import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension AuthorLink.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any AuthorLink.List.Interactor.Interface,
                any AuthorLink.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            let authorID = try context.requiredID()
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: AuthorLink.Permissions.list
            )
            let emptyModel = AuthorLink.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )

            let model: AuthorLink.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.list(
                        authorID: authorID,
                        page: page,
                        search: search
                    )
                    error = nil
                }
                catch let caughtError {
                    model = emptyModel
                    error = caughtError.displayMessage
                }
            }
            else {
                model = emptyModel
                error = nil
            }

            return try await presenter.render(
                authorID: authorID,
                model: model,
                permissions: permissions,
                search: search,
                error: error
            )
        }
    }
}
