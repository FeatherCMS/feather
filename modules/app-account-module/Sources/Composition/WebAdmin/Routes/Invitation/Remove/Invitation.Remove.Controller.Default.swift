import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove.Controller {

    struct Default: Interface {
        let routes: Invitation.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Invitation.Remove.Interactor.Interface,
                any Invitation.Remove.Presenter.Interface
            >

        func postRemovePath(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.invitations.path,
                            title: "Expired",
                            message:
                                "This form has expired. Please reload the page."
                        )
                    ]
                )
            }
            let ids = nonceRequest.input.normalizedIds
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: routes.invitations.path
                    ]
                )
            }
            do {
                try await interactor.execute(ids: ids)
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.invitations.path + "/",
                            title: "Removed",
                            message: ids.count == 1
                                ? "User invitation removed successfully."
                                : "User invitations removed successfully."
                        )
                    ]
                )
            }
            catch let error as OpenAPIRepositoryError {
                return
                    try await presenter.renderErrorPage(
                        id: ids[0],
                        info: error.errorTitle,
                        message: error.errorDescription
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
