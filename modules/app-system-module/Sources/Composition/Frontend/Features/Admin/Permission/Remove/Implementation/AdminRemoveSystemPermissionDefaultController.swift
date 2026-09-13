import FeatherAdmin
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
                try await presenter
                .renderErrorPage(
                    error: .forbidden,
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
                try await presenter
                .renderRemovePage(
                    page: page,
                    search: search,
                    ids: ids,
                    names: try await interactor.names(ids: ids),
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch let error as AdminRemoveSystemPermissionError {
            return
                try await presenter
                .renderErrorPage(
                    error: error,
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
                try await presenter
                .renderErrorPage(
                    error: .forbidden,
                    cancel: SystemPermissionRoutes.list.description
                )
                .response(from: request, context: context)
        }

        var returnTo = request.queryString("returnTo")
        do {
            let payload = try await request.decode(
                as: NonceRequest<NewAdminListRemoveFormInput>.self,
                context: context
            )
            returnTo = payload.input.normalizedReturnTo
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return
                    try await presenter
                    .renderInvalidNoncePage(
                        cancel: NewAdminLocation.removeCancel(
                            path: SystemPermissionRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }

            let ids = payload.input.normalizedIds
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: NewAdminLocation.url(
                            path: SystemPermissionRoutes.list.description,
                            page: payload.input.normalizedPage,
                            search: payload.input.normalizedSearch
                        )
                    ]
                )
            }
            try await interactor.delete(ids: ids)
            return presenter.renderSuccess(
                location: NewAdminLocation.url(
                    path: SystemPermissionRoutes.list.description,
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch
                ),
                count: ids.count
            )
        }
        catch let error as AdminRemoveSystemPermissionError {
            return
                try await presenter
                .renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: SystemPermissionRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
