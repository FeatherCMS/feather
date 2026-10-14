import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminRemoveSystemPermissionDefaultController:
    AdminRemoveSystemPermissionController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveSystemPermissionInteractor,
            any AdminRemoveSystemPermissionPresenter
        >

    func postRemoveSystemPermissions(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
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
                as: NonceRequest<AdminListRemoveFormInput>.self,
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
                        cancel: AdminLocation.removeCancel(
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
                        .location: AdminLocation.url(
                            path: SystemPermissionRoutes.list.description,
                            page: payload.input.normalizedPage,
                            search: payload.input.normalizedSearch
                        )
                    ]
                )
            }
            try await interactor.delete(ids: ids)
            return presenter.renderSuccess(
                location: AdminLocation.url(
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
                    cancel: AdminLocation.removeCancel(
                        path: SystemPermissionRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
