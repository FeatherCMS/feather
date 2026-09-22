import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormSubmissionsDefaultController:
    AdminRemoveContactFormSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFormSubmissionsInteractor,
            presenter: any AdminRemoveContactFormSubmissionsPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formKey")
        let submissionId = try context.requiredParameter("submissionId")
        let submission = try await interactor.get(
            formId: formId,
            id: submissionId
        )
        return try await presenter.renderRemovePage(
            formId: formId,
            items: [.init(id: submission.id, label: submission.createdAt)]
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formKey")
        let submissionId = try context.requiredParameter("submissionId")
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
        try await interactor.remove(formId: formId, id: submissionId)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/submissions/",
                    title: "Removed",
                    message: "Contact form submission removed successfully."
                )
            ]
        )
    }

    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return try await presenter.renderRemovePage(
            formId: try context.requiredParameter("formKey"),
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
        let formId = try context.requiredParameter("formKey")
        let payload = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(
            formId: formId,
            ids: payload.input.normalizedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/submissions/",
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch,
                    title: "Removed",
                    message: "Contact form submissions removed successfully."
                )
            ]
        )
    }
}
