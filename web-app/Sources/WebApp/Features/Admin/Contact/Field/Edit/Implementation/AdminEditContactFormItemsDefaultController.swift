import Hummingbird

struct AdminEditContactFormItemsDefaultController:
    AdminEditContactFormItemsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditContactFormItemsInteractor,
            presenter: any AdminEditContactFormItemsPresenter
        )
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("itemId")
        do {
            return presenter.renderPage(
                formId: formId,
                item: try await interactor.get(formId: formId, id: id),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderPage(
                formId: formId,
                item: .init(
                    id: id,
                    formId: formId,
                    key: "",
                    type: "text",
                    label: "",
                    allowedValues: "",
                    isRequired: false,
                    position: "0"
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let id = try context.requiredParameter("itemId")
        let form = try await request.decode(
            as: ContactFormItemAddForm.self,
            context: context
        )
        let basePath = "/admin/contact/forms/\(formId)/items/"
        do {
            try await interactor.update(formId: formId, id: id, form: form)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: basePath,
                        title: "Updated",
                        message: "Contact form field updated successfully."
                    )
                ]
            )
        }
        catch {
            return
                try presenter.renderPage(
                    formId: formId,
                    item: .init(
                        id: id,
                        formId: formId,
                        key: form.key,
                        type: form.type,
                        label: form.label,
                        allowedValues: form.allowedValues,
                        isRequired: form.isRequiredValue,
                        position: form.position
                    ),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
