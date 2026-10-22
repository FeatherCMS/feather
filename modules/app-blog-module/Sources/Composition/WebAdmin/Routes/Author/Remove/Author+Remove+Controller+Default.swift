import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

extension Author.Remove.Controller {
    struct Default: Interface {
        let routes: Author.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Author.Remove.Interactor.Interface,
                any Author.Remove.Presenter.Interface
            >

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime((request, context))
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return Response(status: .badRequest)
            }

            let ids = nonceRequest.input.normalizedSelectedIds
            let location = AdminLocation.url(
                path: routes.authors.description + "/",
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
                return AdminNotificationFlash.redirect(
                    to: location,
                    notification: .init(
                        title: "Removed",
                        message: ids.count == 1
                            ? "Blog author removed successfully."
                            : "Blog authors removed successfully."
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter
                    .renderError(
                        info: error.errorTitle,
                        message: error.errorDescription
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
