import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Post.List.Interactor.Interface,
                any Post.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Post.Permissions.list
            )
            let emptyModel = Post.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )

            let model: Post.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.list(
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
                model: model,
                permissions: permissions,
                search: search,
                error: error
            )
        }
    }
}
