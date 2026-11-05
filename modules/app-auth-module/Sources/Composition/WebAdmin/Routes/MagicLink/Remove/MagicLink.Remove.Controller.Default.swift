import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension MagicLink.Remove.Controller {
    struct Default: Interface {
        let routes: MagicLink.Router.Routes

        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any MagicLink.Remove.Interactor.Interface,
                any MagicLink.Remove.Presenter.Interface
            >

        func postAuthMagicLinksRemove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: MagicLink.Permissions.delete
                )
            else {
                return
                    try await presenter.renderError(
                        item: .init(id: "", label: ""),
                        error: .forbidden
                    )
                    .response(from: request, context: context)
            }
            let nonceRequest = try await request.decode(
                as: NonceRequest<MagicLink.Remove.Request.Input>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return try await presenter.renderInvalidNoncePage()
                    .response(from: request, context: context)
            }
            let payload = nonceRequest.input
            let ids = payload.normalizedSelectedIds
            let location = listLocation(
                page: payload.normalizedPage,
                search: payload.normalizedSearch,
                userID: payload.normalizedUserID
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            do {
                try await interactor.remove(ids: ids)
                return AdminNotification.redirect(
                    to: location,
                    notification: .init(
                        title: "Removed",
                        message: "User magic link removed successfully."
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return
                    try await presenter.renderError(
                        item: .init(id: ids.joined(separator: ", "), label: ""),
                        error: error
                    )
                    .response(from: request, context: context)
            }
        }

        private func listLocation(page: Int, search: String?, userID: String?)
            -> String
        {
            var components = URLComponents(string: routes.list.path)!
            components.queryItems = [
                .init(name: "page", value: "\(page)"),
                .init(name: "search", value: search),
                .init(name: "userId", value: userID),
            ]
            .compactMap { $0.value == nil || $0.value!.isEmpty ? nil : $0 }
            return components.string ?? routes.list.path
        }
    }
}
