import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormFieldDefaultController:
    AdminRemoveContactFormFieldController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminRemoveContactFormFieldInteractor,
            any AdminRemoveContactFormFieldPresenter
        >
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        let id = try context.requiredParameter("fieldId")
        let field = try? await interactor.get(formId: formId, id: id)
        return try await presenter.renderRemovePage(
            formId: formId,
            items: [.init(id: id, label: field?.label ?? id)]
        )
    }
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let formId = context.parameters.get("formId", as: String.self) ?? ""
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
            formId: formId,
            id: try context.requiredParameter("fieldId")
        )
        let basePath = "/admin/contact/forms/\(formId)/fields/"
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: basePath,
                    title: "Removed",
                    message: "Contact form field removed successfully."
                )
            ]
        )
    }
    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime((request, context))
        return try await presenter.renderRemovePage(
            formId: try context.requiredParameter("formId"),
            items: request.queryStrings("selectedIds")
                .map {
                    .init(id: $0, label: $0)
                }
        )
    }
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let formId = try context.requiredParameter("formId")
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let (interactor, _) = buildRuntime((request, context))
        try await interactor.remove(
            formId: formId,
            ids: payload.normalizedSelectedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/fields/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact form fields removed successfully."
                )
            ]
        )
    }
}
