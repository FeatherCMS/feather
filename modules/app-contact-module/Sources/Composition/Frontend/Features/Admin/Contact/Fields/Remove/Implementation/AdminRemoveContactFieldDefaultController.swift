import ContactContracts
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFieldDefaultController:
    AdminRemoveContactFieldController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFieldInteractor,
            presenter: any AdminRemoveContactFieldPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return try await presenter.renderForbiddenPage()
        }
        let id = try context.requiredParameter("fieldId")
        let field = try? await interactor.get(id: id)
        return try await presenter.renderRemovePage(
            items: [.init(id: id, label: field?.label ?? id)]
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        try await interactor.remove(
            id: try context.requiredParameter("fieldId")
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: "/admin/contact/fields/",
                    title: "Removed",
                    message: "Contact field removed successfully."
                )
            ]
        )
    }

    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return try await presenter.renderForbiddenPage()
        }
        return try await presenter.renderRemovePage(
            items: request.queryStrings("ids")
                .map {
                    .init(id: $0, label: $0)
                }
        )
    }

    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(status: .badRequest)
        }
        try await interactor.remove(ids: payload.input.normalizedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/fields/",
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch,
                    title: "Removed",
                    message: "Contact fields removed successfully."
                )
            ]
        )
    }

}
