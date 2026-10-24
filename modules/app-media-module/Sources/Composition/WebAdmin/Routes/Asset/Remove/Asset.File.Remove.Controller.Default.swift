import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Remove.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Asset.File.Remove.Interactor.Interface,
                any Asset.File.Remove.Presenter.Interface
            >
        let routes: Asset.Router.Routes

        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let interactor = buildRuntime(request, context).interactor
            guard context.isCurrentUserAllowed(to: Asset.Permissions.delete)
            else { return Response(status: .forbidden) }
            let payload = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return Response(status: .badRequest)
            }
            let ids = payload.input.normalizedIds
            let location = AdminLocation.removeCancel(
                path: routes.file.list.path,
                returnTo: payload.input.normalizedReturnTo
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            do {
                try await interactor.remove(ids: ids)
                return AdminNotificationFlash.redirect(
                    to: location,
                    notification: .init(
                        title: "Removed",
                        message: ids.count == 1
                            ? "Media item removed successfully."
                            : "Media items removed successfully."
                    )
                )
            }
            catch {
                return AdminNotificationFlash.redirect(
                    to: location,
                    notification: .init(
                        title: "Remove failed",
                        message: error.displayMessage
                    )
                )
            }
        }
    }
}
