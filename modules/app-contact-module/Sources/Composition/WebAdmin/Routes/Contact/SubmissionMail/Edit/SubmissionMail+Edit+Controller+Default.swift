import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Edit.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any SubmissionMail.Edit.Interactor.Interface,
                any SubmissionMail.Edit.Presenter.Interface
            >
        let routes: Contact.Router.Routes

        func edit(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let formId = try context.requiredParameter("formKey")
            let mailId = try context.requiredParameter("mailId")
            do {
                let form = try await interactor.get(id: formId)
                guard let mail = form.mails.first(where: { $0.id == mailId })
                else {
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
                        additionalHeaders: [],
                        messageBody: ""
                    ),
                    availableFields: [],
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }

        func update(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let interactor = buildRuntime(request, context).interactor
            let formId = try context.requiredParameter("formKey")
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
                        defaultPath: routes.formEmailsPath(formId),
                        title: "Updated",
                        message: "Contact form email updated successfully."
                    )
                ]
            )
        }
    }
}
