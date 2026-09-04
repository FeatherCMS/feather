import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetContactFormSubmissionDefaultController:
    AdminGetContactFormSubmissionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetContactFormSubmissionInteractor,
            presenter: any AdminGetContactFormSubmissionPresenter
        )

    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let submissionId = try context.requiredParameter("submissionId")
        do {
            return presenter.renderPage(
                formId: formId,
                item: try await interactor.get(
                    formId: formId,
                    id: submissionId
                ),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderPage(
                formId: formId,
                item: .init(
                    id: submissionId,
                    formId: formId,
                    status: "received",
                    createdAt: "",
                    email: nil,
                    values: [:]
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
