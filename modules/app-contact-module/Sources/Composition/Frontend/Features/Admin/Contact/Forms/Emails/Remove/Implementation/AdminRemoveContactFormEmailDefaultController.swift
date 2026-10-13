import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormEmailDefaultController:
    AdminRemoveContactFormEmailController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveContactFormEmailInteractor,
            any AdminRemoveContactFormEmailPresenter
        >

    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formKey")
        let ids = request.queryStrings("ids")
        if ids.count == 1, let mailId = ids.first {
            let form = try await interactor.get(id: formId)
            guard let mail = form.mails.first(where: { $0.id == mailId }) else {
                throw HTTPError(.notFound)
            }
            return try await presenter.renderRemovePage(
                formId: formId,
                items: [.init(id: mail.id, label: mail.subject)]
            )
        }
        return try await presenter.renderRemovePage(
            formId: formId,
            items:
                ids
                .map {
                    .init(id: $0, label: $0)
                }
        )
    }

    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        let (interactor, _) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formKey")
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        try await interactor.remove(
            id: formId,
            emailIds: payload.input.normalizedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/emails/",
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch,
                    title: "Removed",
                    message: "Contact form emails removed successfully."
                )
            ]
        )
    }
}
