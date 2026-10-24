import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.Remove.Controller {
    struct Default: Interface {
        let routes: Rule.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Rule.Remove.Interactor.Interface,
                any Rule.Remove.Presenter.Interface
            >

        func postRemoveRedirectRule(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: Rule.Permissions.delete)
            else {
                return try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            let id = try context.requiredID()
            do {
                let payload = try await request.decode(
                    as: NonceRequest<AdminListRemoveFormInput>.self,
                    context: context
                )
                guard
                    await AdminNonceStore.shared.consume(
                        payload.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    return
                        try await presenter.renderInvalidNoncePage(
                            cancel: AdminLocation.removeCancel(
                                path: routes.list.path,
                                returnTo: request.queryString("returnTo")
                            )
                        )
                        .response(from: request, context: context)
                }
                try await interactor.delete(ids: [id])
                let location = AdminLocation.removeCancel(
                    path: routes.list.path,
                    returnTo: payload.input.normalizedReturnTo
                )
                return presenter.renderSuccess(location: location, count: 1)
            }
            catch let error as Rule.Remove.Error {
                return
                    try await presenter.renderErrorPage(
                        error: error,
                        cancel: AdminLocation.removeCancel(
                            path: routes.list.path,
                            returnTo: request.queryString("returnTo")
                        )
                    )
                    .response(from: request, context: context)
            }
        }

        func postRemoveRedirectRules(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: Rule.Permissions.delete)
            else {
                return try await presenter.renderForbiddenPage()
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
                        try await presenter.renderInvalidNoncePage(
                            cancel: AdminLocation.removeCancel(
                                path: routes.list.path,
                                returnTo: returnTo
                            )
                        )
                        .response(from: request, context: context)
                }
                let ids = payload.input.normalizedIds
                if !ids.isEmpty { try await interactor.delete(ids: ids) }
                let location = AdminLocation.removeCancel(
                    path: routes.list.path,
                    returnTo: returnTo
                )
                guard !ids.isEmpty else {
                    return Response(
                        status: .seeOther,
                        headers: [.location: location]
                    )
                }
                return presenter.renderSuccess(
                    location: location,
                    count: ids.count
                )
            }
            catch let error as Rule.Remove.Error {
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
