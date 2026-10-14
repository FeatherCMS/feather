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


    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formKey")
        let submissionId = try context.requiredParameter("submissionId")
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
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


    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let formId = try context.requiredParameter("formKey")
        let payload = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
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
