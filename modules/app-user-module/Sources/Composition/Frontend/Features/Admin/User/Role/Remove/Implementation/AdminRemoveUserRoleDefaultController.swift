import FeatherAdmin
import Hummingbird
import UserContracts

struct AdminRemoveUserRoleDefaultController: AdminRemoveUserRoleController {
    let buildRuntime: RuntimeBuilder<
        any AdminRemoveUserRoleInteractor,
        any AdminRemoveUserRolePresenter
    >

    func getRemoveUserRole(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.delete)
        else { return try await presenter.renderForbiddenPage() }
        let id = try context.requiredID()
        do {
            let names = try await interactor.names(ids: [id])
            return try await presenter.renderRemovePage(
                items: [.init(id: id, label: names.first ?? id)],
                returnTo: request.queryString("returnTo")
            )
        }
        catch let error as AdminRemoveUserRoleError {
            return try await presenter.renderErrorPage(
                error: error,
                cancel: UserRoleRoutes.list.description
            )
        }
    }

    func postRemoveUserRole(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.delete)
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
                        cancel: UserRoleRoutes.list.description
                    )
                    .response(from: request, context: context)
            }
            try await interactor.delete(ids: [id])
            return presenter.renderSuccess(
                location: UserRoleRoutes.list.description,
                count: 1
            )
        }
        catch let error as AdminRemoveUserRoleError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: UserRoleRoutes.list.description
                )
                .response(from: request, context: context)
        }
    }

    func getRemoveUserRoles(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.delete)
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
                        path: UserRoleRoutes.list.description,
                        page: page,
                        search: search
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
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch let error as AdminRemoveUserRoleError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: UserRoleRoutes.list.description,
                        returnTo: request.queryString("returnTo")
                    )
                )
                .response(from: request, context: context)
        }
    }

    func postRemoveUserRoles(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.delete)
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
                            path: UserRoleRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
            if !payload.input.normalizedIds.isEmpty {
                try await interactor.delete(ids: payload.input.normalizedIds)
            }
            let location = NewAdminLocation.url(
                path: UserRoleRoutes.list.description,
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
        catch let error as AdminRemoveUserRoleError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: UserRoleRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
