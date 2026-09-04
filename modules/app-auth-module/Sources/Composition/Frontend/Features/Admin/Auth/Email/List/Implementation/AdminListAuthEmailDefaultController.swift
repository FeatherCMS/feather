import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import FeatherValidationFoundation
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

struct AdminListAuthEmailDefaultController: AdminListAuthEmailController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListAuthEmailInteractor,
            presenter: any AdminListAuthEmailPresenter
        )

    func getAuthEmails(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissionSet = context.currentUserPermissions
        let permissions = AuthPermissions.Emails.list
        let canAccess = context.isCurrentUserAllowed(
            to: permissions
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()
        let userID = request.uri.queryParameters["userId"].map(String.init)

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
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your identity cannot access user emails.",
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Auth", link: "/admin/auth/"),
                    .init(
                        label: "Emails",
                        link: "/admin/auth/emails/"
                    ),
                ])
            )
            return presenter.renderPage(state: state)
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error)
        }
    }

    func getAuthEmailsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        let userID = request.uri.queryParameters["userId"].map(String.init)
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListRemoveRedirect.location(
                        path: "/admin/auth/emails/",
                        page: page,
                        search: search,
                        queryItems: userID.map { [("userId", $0)] } ?? [],
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return
            try presenter.renderRemoveConfirmation(
                selectedIds: selectedIds,
                page: page,
                search: search,
                userID: userID,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postAuthEmailsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: AdminListAuthEmailRemoveInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListRemoveRedirect.location(
                    path: "/admin/auth/emails/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    queryItems: payload.normalizedUserID.map {
                        [("userId", $0)]
                    } ?? [],
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "User email removed successfully." : nil
                )
            ]
        )
    }
}
