import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
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

struct AdminListAuthEmailDefaultController: AdminListAuthEmailController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListAuthEmailInteractor,
            any AdminListAuthEmailPresenter
        >

    func getAuthEmails(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let permissionSet = context.currentUserPermissions
        let permissions = AuthPermissions.Emails.list
        let canAccess = context.isCurrentUserAllowed(
            to: permissions
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()
        let userID = request.uri.queryParameters["userId"].map(String.init)
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.list)
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
                    identityNames: [:],
                    total: 0,
                    page: page,
                    size: pageSize
                )

            let state = AuthEmailTable.State(
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                canAccess: canAccess,
                permissions: permissionSet,
                canAdd: permissionSet.contains(
                    AuthPermissions.Emails.create.rawValue
                ),
                links: result.items,
                identityNames: result.identityNames,
                page: result.page,
                pageSize: result.size,
                total: result.total,
                search: search ?? "",
                userID: userID,
                breadcrumb: AuthEmailRoutes.listBreadcrumb
            )
            return try await presenter.renderPage(state: state)
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(error: error)
        }
    }
}
