import BlogAdminAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension AuthorLink.Remove.Controller {
    struct Default: Interface {
        let routes: BlogWebAdmin.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any AuthorLink.Remove.Interactor.Interface,
                any AuthorLink.Remove.Presenter.Interface
            >

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime((request, context))
            let authorID = try context.requiredID()
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
                path: routes.author(RouterPath(authorID)).description,
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
                try await runtime.interactor.delete(
                    authorID: authorID,
                    ids: ids
                )
                return AdminNotificationFlash.redirect(
                    to: location,
                    notification: .init(
                        title: "Removed",
                        message: ids.count == 1
                            ? "Link removed successfully."
                            : "Links removed successfully."
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter
                    .renderError(
                        authorID: authorID,
                        info: error.errorTitle,
                        message: error.errorDescription
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
