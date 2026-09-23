import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormEmailDefaultController:
    AdminEditContactFormEmailController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminEditContactFormEmailInteractor,
            any AdminEditContactFormEmailPresenter
        >

    func edit(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formId")
        let mailId = try context.requiredParameter("mailId")
        do {
            let form = try await interactor.get(id: formId)
            guard let mail = form.mails.first(where: { $0.id == mailId }) else {
                throw HTTPError(.notFound)
            }
            let fields = form.availableFields.filter {
                form.selectedFieldIDs.contains($0.id)
            }
            return try await presenter.renderPage(
                formId: formId,
                mail: mail,
                availableFields: fields,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderPage(
                formId: formId,
                mail: .init(
                    id: mailId,
                    mailFrom: "",
                    mailTo: "",
                    subject: "",
                    additionalHeaders: "",
                    messageBody: ""
                ),
                availableFields: [],
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func update(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formId")
        let mailId = try context.requiredParameter("mailId")
        let input = try await request.decode(
            as: SubmissionMailFormInput.self,
            context: context
        )
        try await interactor.update(
            id: formId,
            email: .init(
                id: mailId,
                mailFrom: input.mail.mailFrom,
                mailTo: input.mail.mailTo,
                subject: input.mail.subject,
                additionalHeaders: input.mail.additionalHeaders,
                messageBody: input.mail.messageBody
            )
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/emails/",
                    title: "Updated",
                    message: "Contact form email updated successfully."
                )
            ]
        )
    }
}
