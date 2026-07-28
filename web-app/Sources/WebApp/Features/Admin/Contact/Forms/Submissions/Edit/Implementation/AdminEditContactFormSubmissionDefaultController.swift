import Hummingbird

struct AdminEditContactFormSubmissionDefaultController:
    AdminEditContactFormSubmissionController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditContactFormSubmissionInteractor,
            presenter: any AdminEditContactFormSubmissionPresenter
        )

    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
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
                    .location: AdminToastRedirect.location(
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
                try presenter.renderError(
                    formId: formId,
                    id: submissionId,
                    message: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
