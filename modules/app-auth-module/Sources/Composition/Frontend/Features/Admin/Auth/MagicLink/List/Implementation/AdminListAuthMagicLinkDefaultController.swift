import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemModuleWebAdmin
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminListAuthMagicLinkDefaultController: AdminListAuthMagicLinkController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListAuthMagicLinkInteractor,
            any AdminListAuthMagicLinkPresenter
        >

    func getAuthMagicLinks(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let permissionSet = context.currentUserPermissions
        let permissions = AuthPermissions.MagicLinks.list
        let canAccess = context.isCurrentUserAllowed(
            to: permissions
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()
        let userID = request.uri.queryParameters["userId"].map(String.init)
        guard context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.list)
        else {
            return try await presenter.renderError(error: .forbidden)
        }

        do {
            let result =
                canAccess
                ? try await interactor.execute(
                    page: page,
                    size: pageSize,
                    search: search,
                    userID: userID
                )
                : (
                    items: [],
                    emailByAuthEmailId: [:],
                    total: 0,
                    page: page,
                    size: pageSize
                )

            let state = AuthMagicLinkTable.State(
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                canAccess: canAccess,
                permissions: permissionSet,
                canAdd: permissionSet.contains(
                    AuthPermissions.MagicLinks.create.rawValue
                ),
                links: result.items,
                emailByAuthEmailId: result.emailByAuthEmailId,
                page: result.page,
                pageSize: result.size,
                total: result.total,
                search: search ?? "",
                userID: userID,
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your identity cannot access user magic links.",
                breadcrumb: AuthMagicLinkRoutes.listBreadcrumb
            )
            return try await presenter.renderPage(state: state)
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(error: error)
        }
    }
}
