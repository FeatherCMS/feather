import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminViewContactFormSubmissionDefaultController:
    AdminViewContactFormSubmissionController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminViewContactFormSubmissionInteractor,
            any AdminViewContactFormSubmissionPresenter
        >

    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let formId = try context.requiredParameter("formKey")
        let submissionId = try context.requiredParameter("submissionId")
        do {
            return try await presenter.renderDetailsPage(
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
            return try await presenter.renderDetailsPage(
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
