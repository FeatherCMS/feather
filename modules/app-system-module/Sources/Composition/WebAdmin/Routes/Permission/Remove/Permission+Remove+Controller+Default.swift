import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Permission.Remove.Controller {
    struct Default:
        Interface
    {
        let routes: Permission.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Permission.Remove.Interactor.Interface,
                any Permission.Remove.Presenter.Interface
            >

        func postRemoveSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Permission.Permissions.delete
                )
            else {
                return
                    try await presenter
                    .renderErrorPage(
                        error: .forbidden,
                        cancel: routes.list.path
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
                                path: routes.list.path,
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
                                path: routes.list.path,
                                page: payload.input.normalizedPage,
                                search: payload.input.normalizedSearch
                            )
                        ]
                    )
                }
                try await interactor.delete(ids: ids)
                return presenter.renderSuccess(
                    location: AdminLocation.url(
                        path: routes.list.path,
                        page: payload.input.normalizedPage,
                        search: payload.input.normalizedSearch
                    ),
                    count: ids.count
                )
            }
            catch let error
                as Permission.Remove.Error
            {
                return
                    try await presenter
                    .renderErrorPage(
                        error: error,
                        cancel: AdminLocation.removeCancel(
                            path: routes.list.path,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
