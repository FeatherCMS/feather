import Hummingbird

struct AdminRemoveContactFormEmailDefaultController:
    AdminRemoveContactFormEmailController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveContactFormEmailInteractor,
            presenter: any AdminRemoveContactFormEmailPresenter
        )

    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let mailId = try context.requiredParameter("mailId")
        do {
            let form = try await interactor.get(id: formId)
            guard let mail = form.mails.first(where: { $0.id == mailId }) else {
                throw HTTPError(.notFound)
            }
            return presenter.renderPage(
                formId: formId,
                mail: mail,
                permissions: context.currentUserPermissions
            )
        }
        catch { throw error }
    }

    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let mailId = try context.requiredParameter("mailId")
        try await interactor.remove(id: formId, emailId: mailId)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/emails/",
                    title: "Removed",
                    message: "Contact form email removed successfully."
                )
            ]
        )
    }
}
