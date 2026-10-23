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

extension Email.List.Controller {
    struct Default: Interface {
        let routes: Email.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Email.List.Interactor.Interface,
                any Email.List.Presenter.Interface
            >

        func getAuthEmails(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissionSet = context.currentUserPermissions
            let permissions = Email.Permissions.list
            let canAccess = context.isCurrentUserAllowed(
                to: permissions
            )
            let page = request.queryPage()
            let pageSize = 20
            let search = request.querySearch()
            let userID = request.uri.queryParameters["userId"].map(String.init)
            guard
                context.isCurrentUserAllowed(to: Email.Permissions.list)
            else {
                return try await presenter.renderError(error: .forbidden)
            }

            do {
                let result: Email.List.Result =
                    canAccess
                    ? try await interactor.execute(
                        page: page,
                        size: pageSize,
                        search: search,
                        userID: userID
                    )
                    : .init(
                        items: [],
                        identityNames: [:],
                        total: 0,
                        page: page,
                        size: pageSize
                    )

                let state = Email.List.ListTable.State(
                    isAdded: request.hasQueryFlag("added"),
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    canAccess: canAccess,
                    permissions: permissionSet,
                    canAdd: permissionSet.contains(
                        Email.Permissions.create.rawValue
                    ),
                    links: result.items,
                    identityNames: result.identityNames,
                    page: result.page,
                    pageSize: result.size,
                    total: result.total,
                    search: search ?? "",
                    userID: userID,
                    breadcrumb: routes.listBreadcrumb,
                    routes: routes
                )
                return try await presenter.renderPage(state: state)
            }
            catch let error as OpenAPIRepositoryError {
                return try await presenter.renderError(error: error)
            }
        }
    }
}
