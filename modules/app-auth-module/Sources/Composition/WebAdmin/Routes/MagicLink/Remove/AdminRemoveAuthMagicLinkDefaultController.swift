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

struct AdminRemoveAuthMagicLinkDefaultController:
    AdminRemoveAuthMagicLinkController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveAuthMagicLinkInteractor,
            any AdminRemoveAuthMagicLinkPresenter
        >

    func postAuthMagicLinksRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
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
            as: NonceRequest<AdminListAuthMagicLinkRemoveInput>.self,
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
            return Response(status: .seeOther, headers: [.location: location])
        }
        do {
            try await interactor.remove(ids: ids)
            return AdminNotificationFlash.redirect(
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
        var components = URLComponents(string: "/admin/auth/magic-links/")!
        components.queryItems = [
            .init(name: "page", value: "\(page)"),
            .init(name: "search", value: search),
            .init(name: "userId", value: userID),
        ]
        .compactMap { $0.value == nil || $0.value!.isEmpty ? nil : $0 }
        return components.string ?? "/admin/auth/magic-links/"
    }
}
