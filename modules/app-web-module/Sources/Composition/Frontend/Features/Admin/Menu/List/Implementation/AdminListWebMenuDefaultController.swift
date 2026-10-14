import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminListWebMenuDefaultController:
    AdminListWebMenuController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListWebMenuInteractor,
            any AdminListWebMenuPresenter
        >

    func getWebMenus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebPermissions.Menus.list
        )
        let emptyModel = AdminListWebMenuModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebMenuModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listWebMenus(
                    page: page,
                    search: search
                )
                error = nil
            }
            catch let caughtError {
                model = emptyModel
                error = caughtError.displayMessage
            }
        }
        else {
            model = emptyModel
            error = nil
        }
        return try await presenter.renderListPage(
            model: model,
            permissions: permissions,
            search: search,
            error: error
        )
    }
    func postWebMenusRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime((request, context))
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let payload = nonceRequest.input
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = AdminLocation.url(
            path: "/admin/web/menus/",
            page: payload.normalizedPage,
            search: payload.normalizedSearch
        )
        guard !payload.normalizedSelectedIds.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "Menu removed successfully."
            )
        )
    }
}
