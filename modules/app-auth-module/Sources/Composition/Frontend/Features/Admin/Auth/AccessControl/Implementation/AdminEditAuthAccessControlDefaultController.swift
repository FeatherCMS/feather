import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
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
import WebComponents
import WebBuilders

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
        let canList = permissions.contains("auth:access-control:list")
        let canEdit = permissions.contains("auth:access-control:update")
        guard canList else {
            return presenter.deniedPage(
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
            return presenter.renderPage(
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
            return presenter.renderPage(
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
        let canEdit = permissions.contains("auth:access-control:update")
        guard canEdit else {
            return
                try presenter.deniedPage(
                    permissions: permissions,
                    message: "Your identity cannot manage access control."
                )
                .response(from: request, context: context)
        }

        let payload = try await request.decode(
            as: AdminEditAuthAccessControlFormInput.self,
            context: context
        )

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
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminToastRedirect.location(
                            defaultPath: "/admin/auth/access-control/",
                            title: "Saved",
                            message: "Access Control edited successfully.",
                            extraQueryItems: query
                        )
                    ]
                )
            case .render(let state):
                return
                    try presenter.renderPage(
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
                try presenter.renderPage(
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
