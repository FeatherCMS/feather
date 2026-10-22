import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Remove.Controller {
    struct Default:
        Variant.Remove.Controller.Interface
    {
        let routes: Variant.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Variant.Remove.Interactor.Interface,
                any Variant.Remove.Presenter.Interface
            >

        func postRemoveMediaVariants(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let (interactor, presenter) = buildRuntime((request, context))
            guard context.isCurrentUserAllowed(to: Variant.Permissions.delete)
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
                let location = AdminLocation.url(
                    path: routes.list.path,
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch
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
            catch let error as Variant.Remove.Error {
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
