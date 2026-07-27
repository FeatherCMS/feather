import Hummingbird

struct AdminAddNewsletterIssueDefaultController:
    AdminAddNewsletterIssueController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddNewsletterIssueInteractor,
            presenter: any AdminAddNewsletterIssuePresenter
        )
    func getAddNewsletterIssue(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let id = context.parameters.get("id", as: String.self) else {
            return HTMLResponse(content: "Bad request", status: .badRequest)
        }
        return presenter.renderPage(
            model: try await interactor.getAddNewsletterIssue(
                newsletterId: id
            ),
            permissions: context.currentUserPermissions
        )
    }
    func postAddNewsletterIssue(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let id = context.parameters.get("id", as: String.self) else {
            return Response(status: .badRequest)
        }
        let payload = try await request.decode(
            as: NewsletterIssueAddForm.self,
            context: context
        )
        let model = try await interactor.postAddNewsletterIssue(
            newsletterId: id,
            payload: payload
        )
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath:
                            "/admin/newsletters/\(model.newsletterId)/issues/",
                        title: "Added",
                        message: "Campaign issue added successfully."
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
