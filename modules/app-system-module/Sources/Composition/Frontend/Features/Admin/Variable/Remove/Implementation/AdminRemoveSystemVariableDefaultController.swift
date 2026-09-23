import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SystemContracts

struct AdminRemoveSystemVariableDefaultController:
    AdminRemoveSystemVariableController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveSystemVariableInteractor,
            any AdminRemoveSystemVariablePresenter
        >

    func getRemoveSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    error: .forbidden,
                    cancel: SystemVariableRoutes.list.description
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
                        path: SystemVariableRoutes.list.description,
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
        catch let error as AdminRemoveSystemVariableError {
            return
                try await presenter
                .renderErrorPage(
                    error: error,
                    cancel: SystemVariableRoutes.list.description
                )
                .response(from: request, context: context)
        }
    }

    func postRemoveSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    error: .forbidden,
                    cancel: SystemVariableRoutes.list.description
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
                    try await presenter
                    .renderInvalidNoncePage(
                        cancel: NewAdminLocation.removeCancel(
                            path: SystemVariableRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }
            if !payload.input.normalizedIds.isEmpty {
                try await interactor.delete(ids: payload.input.normalizedIds)
            }
            let location = NewAdminLocation.url(
                path: SystemVariableRoutes.list.description,
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
        catch let error as AdminRemoveSystemVariableError {
            return
                try await presenter.renderErrorPage(
                    error: error,
                    cancel: NewAdminLocation.removeCancel(
                        path: SystemVariableRoutes.list.description,
                        returnTo: returnTo
                    )
                )
                .response(from: request, context: context)
        }
    }
}
