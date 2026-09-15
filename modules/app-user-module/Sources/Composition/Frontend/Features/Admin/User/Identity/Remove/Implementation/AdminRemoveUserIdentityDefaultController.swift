import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import UserContracts

struct AdminRemoveUserIdentityDefaultController:
    AdminRemoveUserIdentityController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveUserIdentityInteractor,
            presenter: any AdminRemoveUserIdentityPresenter
        )

    func getRemoveUserIdentity(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.delete)
        else { return try await presenter.renderForbiddenPage() }
        let id = try context.requiredID()
        do {
            let names = try await interactor.names(ids: [id])
            return try await presenter.renderRemovePage(
                items: [.init(id: id, label: names.first ?? id)],
                returnTo: request.queryString("returnTo")
            )
        }
        catch let error as AdminRemoveUserIdentityError {
            return try await presenter.renderErrorPage(
                error: error,
                cancel: UserIdentityRoutes.list.description
            )
        }
    }

    func postRemoveUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (removeInteractor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.delete)
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
                        cancel: UserIdentityRoutes.list.description
                    )
                    .response(from: request, context: context)
            }
            try await removeInteractor.delete(ids: [id])
            return presenter.renderSuccess(
                location: UserIdentityRoutes.list.description,
                count: 1
            )
        }
        catch let error as AdminRemoveUserIdentityError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: UserIdentityRoutes.list.description
                )
                .response(from: request, context: context)
        }
    }

    func getRemoveUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.delete)
        else {
            return try await presenter.renderForbiddenPage()
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
                        path: UserIdentityRoutes.list.description,
                        page: page,
                        search: search
                    )
                ]
            )
        }
        do {
            return
                try await presenter.renderRemovePage(
                    items: zip(ids, try await interactor.names(ids: ids)).map {
                        .init(id: $0.0, label: $0.1)
                    },
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch let error as AdminRemoveUserIdentityError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: UserIdentityRoutes.list.description,
                        returnTo: request.queryString("returnTo")
                    )
                )
                .response(from: request, context: context)
        }
    }

    func postRemoveUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (removeInteractor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.delete)
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
                            path: UserIdentityRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
            if !payload.input.normalizedIds.isEmpty {
                try await removeInteractor.delete(
                    ids: payload.input.normalizedIds
                )
            }
            let location = NewAdminLocation.url(
                path: UserIdentityRoutes.list.description,
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
        catch let error as AdminRemoveUserIdentityError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: UserIdentityRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
