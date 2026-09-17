import FeatherAdmin
import Hummingbird
import RedirectContracts

struct AdminRemoveRedirectRuleDefaultController:
    AdminRemoveRedirectRuleController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveRedirectRuleInteractor,
            presenter: any AdminRemoveRedirectRulePresenter
        )

    func getRemoveRedirectRule(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.delete)
        else { return try await presenter.renderForbiddenPage() }
        let id = try context.requiredID()
        do {
            let names = try await interactor.names(ids: [id])
            return try await presenter.renderRemovePage(
                items: [.init(id: id, label: names.first ?? id)],
                returnTo: request.queryString("returnTo")
            )
        }
        catch let error as AdminRemoveRedirectRuleError {
            return try await presenter.renderErrorPage(
                error: error,
                cancel: NewAdminLocation.removeCancel(
                    path: RedirectRuleRoutes.list.description,
                    returnTo: request.queryString("returnTo")
                )
            )
        }
    }

    func postRemoveRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.delete)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        do {
            let payload = try await request.decode(
                as: NonceRequest<NewAdminListRemoveFormInput>.self,
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
                        cancel: NewAdminLocation.removeCancel(
                            path: RedirectRuleRoutes.list.description,
                            returnTo: request.queryString("returnTo")
                        )
                    )
                    .response(from: request, context: context)
            }
            try await interactor.delete(ids: [id])
            let location = NewAdminLocation.removeCancel(
                path: RedirectRuleRoutes.list.description,
                returnTo: payload.input.normalizedReturnTo
            )
            return presenter.renderSuccess(location: location, count: 1)
        }
        catch let error as AdminRemoveRedirectRuleError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: RedirectRuleRoutes.list.description,
                        returnTo: request.queryString("returnTo")
                    )
                )
                .response(from: request, context: context)
        }
    }

    func getRemoveRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.delete)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        let ids = request.queryStrings("ids")
        let page = request.queryPage()
        let search = request.querySearch()
        let returnTo =
            request.queryString("returnTo")
            ?? NewAdminLocation.url(
                path: RedirectRuleRoutes.list.description,
                page: page,
                search: search
            )
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.removeCancel(
                        path: RedirectRuleRoutes.list.description,
                        returnTo: returnTo
                    )
                ]
            )
        }
        do {
            return
                try await presenter.renderRemovePage(
                    items: zip(ids, try await interactor.names(ids: ids))
                        .map {
                            .init(id: $0.0, label: $0.1)
                        },
                    returnTo: returnTo
                )
                .response(from: request, context: context)
        }
        catch let error as AdminRemoveRedirectRuleError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: RedirectRuleRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }

    func postRemoveRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.delete)
        else {
            return try await presenter.renderForbiddenPage()
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
                            path: RedirectRuleRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
            let ids = payload.input.normalizedIds
            if !ids.isEmpty { try await interactor.delete(ids: ids) }
            let location = NewAdminLocation.removeCancel(
                path: RedirectRuleRoutes.list.description,
                returnTo: returnTo
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            return presenter.renderSuccess(location: location, count: ids.count)
        }
        catch let error as AdminRemoveRedirectRuleError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: RedirectRuleRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
