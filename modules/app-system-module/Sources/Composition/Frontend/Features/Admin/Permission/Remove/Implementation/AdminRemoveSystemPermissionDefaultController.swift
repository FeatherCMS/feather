import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemContracts

struct AdminRemoveSystemPermissionDefaultController:
    AdminRemoveSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveSystemPermissionInteractor,
            presenter: any AdminRemoveSystemPermissionPresenter
        )

    func getRemoveSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(
                to: SystemPermissions.Permissions.delete
            )
        else {
            return
                try await presenter.renderErrorPage(
                    info: "Forbidden",
                    message: "Your account cannot remove system permissions.",
                    cancel: SystemPermissionRoutes.list.description
                )
                .response(from: request, context: context)
        }
        let ids = request.queryStrings("ids")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.url(
                        path: SystemPermissionRoutes.list.description,
                        page: page,
                        search: search
                    )
                ]
            )
        }
        do {
            return
                try await presenter.renderRemovePage(
                    page: page,
                    search: search,
                    ids: ids,
                    names: try await interactor.names(ids: ids),
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch {
            return
                try await presenter.renderErrorPage(
                    info: "Unable to load system permissions.",
                    message: error.displayMessage,
                    cancel: SystemPermissionRoutes.list.description
                )
                .response(from: request, context: context)
        }
    }

    func postRemoveSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(
                to: SystemPermissions.Permissions.delete
            )
        else {
            return
                try await presenter.renderErrorPage(
                    info: "Forbidden",
                    message: "Your account cannot remove system permissions.",
                    cancel: SystemPermissionRoutes.list.description
                )
                .response(from: request, context: context)
        }
        var page = request.queryPage()
        var search = request.querySearch()
        var returnTo = request.queryString("returnTo")
        do {
            let payload = try await request.decode(
                as: NewAdminListRemoveFormInput.self,
                context: context
            )
            page = payload.normalizedPage
            search = payload.normalizedSearch
            returnTo = payload.normalizedReturnTo
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return
                    try await presenter.renderErrorPage(
                        info: "Forbidden",
                        message:
                            "This confirmation has expired. Please try again.",
                        cancel: NewAdminLocation.removeCancel(
                            path: SystemPermissionRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
            guard !payload.normalizedIds.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: NewAdminLocation.url(
                            path: SystemPermissionRoutes.list.description,
                            page: page,
                            search: search
                        )
                    ]
                )
            }
            try await interactor.delete(ids: payload.normalizedIds)
            let location = NewAdminLocation.url(
                path: SystemPermissionRoutes.list.description,
                page: page,
                search: search
            )
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: payload.normalizedIds.count == 1
                        ? "System permission removed successfully."
                        : "\(payload.normalizedIds.count) system permissions removed successfully."
                )
            )
        }
        catch let error as HTTPError {
            return
                try await presenter.renderErrorPage(
                    info: "Unable to remove system permissions.",
                    message: error.displayMessage,
                    cancel: NewAdminLocation.removeCancel(
                        path: SystemPermissionRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
        catch {
            return
                try await presenter.renderErrorPage(
                    info: "Unable to remove system permissions.",
                    message: error.displayMessage,
                    cancel: NewAdminLocation.removeCancel(
                        path: SystemPermissionRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
