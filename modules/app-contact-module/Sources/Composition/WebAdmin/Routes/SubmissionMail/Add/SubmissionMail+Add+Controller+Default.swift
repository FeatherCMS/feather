import ContactApplication
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

extension SubmissionMail.Add.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any SubmissionMail.Add.Interactor.Interface,
                any SubmissionMail.Add.Presenter.Interface
            >
        let routes: SubmissionMail.Router.Routes

        func add(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let formId = try context.requiredParameter("formKey")
            do {
                let form = try await interactor.get(id: formId)
                let fields = form.availableFields.filter {
                    form.selectedFieldIDs.contains($0.id)
                }
                return try await presenter.renderPage(
                    formId: formId,
                    availableFields: fields,
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await presenter.renderPage(
                    formId: formId,
                    availableFields: [],
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }

        func create(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let interactor = buildRuntime(request, context).interactor
            let formId = try context.requiredParameter("formKey")
            let input = try await request.decode(
                as: SubmissionMail.Form.Input.self,
                context: context
            )
            try await interactor.add(id: formId, email: input.mail)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: routes.formEmailsPath(formId),
                        title: "Added",
                        message: "Contact form email added successfully."
                    )
                ]
            )
        }
    }
}
