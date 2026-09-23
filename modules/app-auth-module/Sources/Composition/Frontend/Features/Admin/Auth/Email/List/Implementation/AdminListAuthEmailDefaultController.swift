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

struct AdminListAuthEmailDefaultController: AdminListAuthEmailController {
    let buildRuntime: RuntimeBuilder<
        any AdminListAuthEmailInteractor,
        any AdminListAuthEmailPresenter
    >

    func getAuthEmails(
        request: Request,
        context: DefaultRequestContext
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

    func getAuthEmailsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime((request, context))
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        let userID = request.uri.queryParameters["userId"].map(String.init)
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.delete)
        else {
            return try await presenter.renderError(error: .forbidden)
                .response(from: request, context: context)
        }
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: listLocation(
                        page: page,
                        search: search,
                        userID: userID
                    )
                ]
            )
        }
        return
            try await presenter.renderRemovePage(
                items: selectedIds.map { .init(id: $0, label: $0) },
                page: page,
                search: search,
                userID: userID
            )
            .response(from: request, context: context)
    }

    func postAuthEmailsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.delete)
        else {
            return try await presenter.renderError(error: .forbidden)
                .response(from: request, context: context)
        }
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListAuthEmailRemoveInput>.self,
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
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = listLocation(
            page: payload.normalizedPage,
            search: payload.normalizedSearch,
            userID: payload.normalizedUserID
        )
        guard !payload.normalizedSelectedIds.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "User email removed successfully."
            )
        )
    }

    private func listLocation(page: Int, search: String?, userID: String?)
        -> String
    {
        var components = URLComponents(string: "/admin/auth/emails/")!
        components.queryItems = [
            .init(name: "page", value: "\(page)"),
            .init(name: "search", value: search),
            .init(name: "userId", value: userID),
        ]
        .compactMap { $0.value == nil || $0.value!.isEmpty ? nil : $0 }
        return components.string ?? "/admin/auth/emails/"
    }
}
