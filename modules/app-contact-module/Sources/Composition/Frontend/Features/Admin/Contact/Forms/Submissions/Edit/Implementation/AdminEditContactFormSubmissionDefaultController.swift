import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormSubmissionDefaultController:
    AdminEditContactFormSubmissionController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminEditContactFormSubmissionInteractor,
            any AdminEditContactFormSubmissionPresenter
        >

    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formId")
        let submissionId = try context.requiredParameter("submissionId")
        let form = try await request.decode(
            as: ContactFormSubmissionStatusForm.self,
            context: context
        )
        do {
            try await interactor.update(
                formId: formId,
                id: submissionId,
                status: form.status
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath:
                            "/admin/contact/forms/\(formId)/submissions/\(submissionId)/",
                        title: "Updated",
                        message: "Submission updated successfully."
                    )
                ]
            )
        }
        catch {
            return
                try await presenter.renderError(
                    formId: formId,
                    id: submissionId,
                    message: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
