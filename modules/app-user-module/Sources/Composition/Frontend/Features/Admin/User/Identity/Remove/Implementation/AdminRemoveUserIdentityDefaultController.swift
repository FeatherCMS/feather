import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import UserContracts

struct AdminRemoveUserIdentityDefaultController:
    AdminRemoveUserIdentityController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveUserIdentityInteractor,
            any AdminRemoveUserIdentityPresenter
        >

    func postRemoveUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (removeInteractor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.delete)
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

    func postRemoveUserIdentities(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (removeInteractor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: UserPermissions.Identities.delete)
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
            let location = AdminLocation.url(
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
                    cancel: AdminLocation.removeCancel(
                        path: UserIdentityRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
