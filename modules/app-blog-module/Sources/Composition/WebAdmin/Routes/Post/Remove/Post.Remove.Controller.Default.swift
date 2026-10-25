import BlogAdminAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Remove.Controller {
    struct Default: Interface {
        let routes: Post.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Post.Remove.Interactor.Interface,
                any Post.Remove.Presenter.Interface
            >

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }

            let ids = nonceRequest.input.normalizedSelectedIds
            let location = AdminLocation.url(
                path: routes.posts.path,
                page: nonceRequest.input.normalizedPage,
                search: nonceRequest.input.normalizedSearch
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }

            do {
                try await runtime.interactor.delete(ids: ids)
                return AdminNotification.redirect(
                    to: location,
                    notification: .init(
                        title: "Removed",
                        message: ids.count == 1
                            ? "Blog post removed successfully."
                            : "Blog posts removed successfully."
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter
                    .renderError(
                        id: ids[0],
                        info: error.errorTitle,
                        message: error.errorDescription
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
