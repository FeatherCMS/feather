import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminEditAuthAccessControlDefaultController:
    AdminEditAuthAccessControlController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditAuthAccessControlInteractor,
            presenter: any AdminEditAuthAccessControlPresenter
        )

    func getAuthAccessControl(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canList = permissions.contains(
            AuthPermissions.AccessControl.list.rawValue
        )
        let canEdit = permissions.contains(
            AuthPermissions.AccessControl.update.rawValue
        )
        guard canList else {
            return try await presenter.deniedPage(
                permissions: permissions,
                message: "Your identity cannot manage access control."
            )
        }

        do {
            let state = try await interactor.loadState(
                isEdited: request.hasQueryFlag("edited"),
                canEdit: canEdit,
                selectedOverride: nil,
                error: nil
            )
            return try await presenter.renderPage(
                state: state,
                permissions: permissions,
                search: request.querySearch() ?? ""
            )
        }
        catch {
            let state = AdminEditAuthAccessControlState(
                isEdited: false,
                error: error.displayMessage,
                canEdit: canEdit,
                roles: [],
                permissions: [],
                selectedPairs: []
            )
            return try await presenter.renderPage(
                state: state,
                permissions: permissions,
                search: request.querySearch() ?? ""
            )
        }
    }

    func postAuthAccessControl(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canEdit = permissions.contains(
            AuthPermissions.AccessControl.update.rawValue
        )
        guard canEdit else {
            return
                try await presenter.deniedPage(
                    permissions: permissions,
                    message: "Your identity cannot manage access control."
                )
                .response(from: request, context: context)
        }

        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminEditAuthAccessControlFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else {
            let state = try await interactor.loadState(
                isEdited: false,
                canEdit: true,
                selectedOverride: nil,
                error: "This form has expired. Please reload the page."
            )
            return
                try await presenter.renderPage(
                    state: state,
                    permissions: permissions,
                    search: request.querySearch() ?? ""
                )
                .response(from: request, context: context)
        }
        let payload = nonceRequest.input

        do {
            switch try await interactor.save(input: payload) {
            case .edited:
                let search =
                    payload.search?
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ) ?? ""
                let query =
                    search.isEmpty
                    ? [] : [URLQueryItem(name: "search", value: search)]
                let location =
                    query.isEmpty
                    ? "/admin/auth/access-control/"
                    : "/admin/auth/access-control/?search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? search)"
                return AdminNotificationFlash.redirect(
                    to: location,
                    notification: .init(
                        title: "Saved",
                        message: "Access Control edited successfully."
                    )
                )
            case .render(let state):
                return
                    try await presenter.renderPage(
                        state: state,
                        permissions: permissions,
                        search: payload.search?
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ) ?? ""
                    )
                    .response(from: request, context: context)
            }
        }
        catch {
            let state = try await interactor.loadState(
                isEdited: false,
                canEdit: true,
                selectedOverride: payload.selectedPairs,
                error: error.displayMessage
            )
            return
                try await presenter.renderPage(
                    state: state,
                    permissions: permissions,
                    search: payload.search?
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ) ?? ""
                )
                .response(from: request, context: context)
        }
    }
}
