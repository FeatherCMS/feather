import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SystemModule

extension Variable.Remove.Controller {
    struct Default: Interface {
        let routes: Variable.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Variable.Remove.Interactor.Interface,
                any Variable.Remove.Presenter.Interface
            >

        func postRemoveSystemVariables(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Variable.Permissions.delete
                )
            else {
                return
                    try await presenter.renderErrorPage(
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
                if !payload.input.normalizedIds.isEmpty {
                    try await interactor.delete(
                        ids: payload.input.normalizedIds
                    )
                }
                let location = AdminLocation.url(
                    path: routes.list.path,
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch
                )
                guard !payload.input.normalizedIds.isEmpty else {
                    return Response(
                        status: .seeOther,
                        headers: [.location: location]
                    )
                }
                return presenter.renderSuccess(
                    location: location,
                    count: payload.input.normalizedIds.count
                )
            }
            catch let error
                as Variable.Remove.Error
            {
                return
                    try await presenter.renderErrorPage(
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
