import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Edit.Controller {
    struct Default: Interface {
        let routes: Contact.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Submission.Edit.Interactor.Interface,
                any Submission.Edit.Presenter.Interface
            >

        func update(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
        {
            let runtime = buildRuntime(request, context)
            let formKey = try context.requiredParameter("formKey")
            let submissionId = try context.requiredParameter("submissionId")
            let form = try await request.decode(
                as: Submission.Edit.StatusForm.self,
                context: context
            )

            do {
                try await runtime.interactor.update(
                    formId: formKey,
                    id: submissionId,
                    status: form.status
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.formSubmissionDetailPath(
                                formKey: formKey,
                                submissionId: submissionId
                            ),
                            title: "Updated",
                            message: "Submission updated successfully."
                        )
                    ]
                )
            }
            catch {
                return try await runtime.presenter
                    .renderError(
                        formId: formKey,
                        id: submissionId,
                        message: error.displayMessage,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
