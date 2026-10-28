import AuthAdminAPI
import AuthModule
import CSS
import FeatherModuleKit
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

extension RolePermission.Edit.Controller {
    struct Default: Interface {
        let routes: RolePermission.Router.Routes

        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any RolePermission.Edit.Interactor.Interface,
                any RolePermission.Edit.Presenter.Interface
            >

        func getAuthAccessControl(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canList = permissions.contains(
                RolePermission.Permissions.list.rawValue
            )
            let canEdit = permissions.contains(
                RolePermission.Permissions.update.rawValue
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
                let state = RolePermission.Edit.State(
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
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canEdit = permissions.contains(
                RolePermission.Permissions.update.rawValue
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
                as: NonceRequest<RolePermission.Edit.Form.Input>.self,
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
                        .whitespaceTrimmed ?? ""
                    let query =
                        search.isEmpty
                        ? [] : [URLQueryItem(name: "search", value: search)]
                    var components = URLComponents(
                        string: routes.edit.path
                    )!
                    components.queryItems = query
                    let location = components.string ?? routes.edit.path
                    return AdminNotification.redirect(
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
                                .whitespaceTrimmed ?? ""
                        )
                        .response(from: request, context: context)
                }
            }
            catch let error as RolePermission.Edit.Error {
                let state = try await interactor.loadState(
                    isEdited: false,
                    canEdit: true,
                    selectedOverride: payload.selectedPairs,
                    error: presenter.format(error: error)
                )
                return
                    try await presenter.renderPage(
                        state: state,
                        permissions: permissions,
                        search: payload.search?
                            .whitespaceTrimmed ?? ""
                    )
                    .response(from: request, context: context)
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
                            .whitespaceTrimmed ?? ""
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
