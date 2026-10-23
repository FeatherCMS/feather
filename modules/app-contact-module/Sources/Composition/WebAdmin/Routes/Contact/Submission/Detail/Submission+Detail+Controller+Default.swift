import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Detail.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Submission.Detail.Interactor.Interface,
                any Submission.Detail.Presenter.Interface
            >

        func get(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
}
