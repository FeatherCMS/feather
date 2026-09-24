import FeatherAdmin
import Hummingbird

struct AdminRemoveContactFormSubmissionsDefaultController:
    AdminRemoveContactFormSubmissionsController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveContactFormSubmissionsInteractor,
            any AdminRemoveContactFormSubmissionsPresenter
        >

    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let formId = try request.requiredParameter("formId")
        let submissionId = try request.requiredParameter("submissionId")
        let submission = try await interactor.get(
            formId: formId,
            id: submissionId
        )
        return try await presenter.renderRemovePage(
            formId: formId,
            items: [.init(id: submission.id, label: submission.createdAt)]
        )
    }

    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let formId = try request.requiredParameter("formId")
        let submissionId = try request.requiredParameter("submissionId")
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

    func confirmSelected(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime((request, context))
        return try await presenter.renderRemovePage(
            formId: try request.requiredParameter("formId"),
            items: request.queryStrings("selectedIds")
                .map {
                    .init(id: $0, label: $0)
                }
        )
    }

    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let formId = try request.requiredParameter("formId")
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
                    path: "/admin/contact/forms/\(formId)/submissions/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact form submissions removed successfully."
                )
            ]
        )
    }
}
