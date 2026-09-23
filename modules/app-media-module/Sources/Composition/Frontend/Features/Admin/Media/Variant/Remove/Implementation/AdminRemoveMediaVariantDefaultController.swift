import FeatherAdmin
import Hummingbird
import MediaContracts

struct AdminRemoveMediaVariantDefaultController:
    AdminRemoveMediaVariantController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminRemoveMediaVariantInteractor,
            any AdminRemoveMediaVariantPresenter
        >

    func getRemoveMediaVariants(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    error: .forbidden,
                    cancel: MediaVariantRoutes.list.description
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
                        path: MediaVariantRoutes.list.description,
                        page: page,
                        search: search
                    )
                ]
            )
        }
        do {
            return
                try await presenter.renderRemovePage(
                    items: try await interactor.names(ids: ids),
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch let error as AdminRemoveMediaVariantError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: MediaVariantRoutes.list.description
                )
                .response(from: request, context: context)
        }
    }

    func postRemoveMediaVariants(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    error: .forbidden,
                    cancel: MediaVariantRoutes.list.description
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
                    try await presenter.renderInvalidNoncePage(
                        cancel: NewAdminLocation.removeCancel(
                            path: MediaVariantRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
            let ids = payload.input.normalizedIds
            if !ids.isEmpty { try await interactor.delete(ids: ids) }
            let location = NewAdminLocation.url(
                path: MediaVariantRoutes.list.description,
                page: payload.input.normalizedPage,
                search: payload.input.normalizedSearch
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            return presenter.renderSuccess(location: location, count: ids.count)
        }
        catch let error as AdminRemoveMediaVariantError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: MediaVariantRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
