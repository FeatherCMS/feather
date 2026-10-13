import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminEditNewsCategoryDefaultController:
    AdminEditNewsCategoryController
{
    let buildRuntime: AdminNewsCategoryRuntimeBuilder

    func getEditNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let item = try await runtime.interactor.get(id: id)
            return try await runtime.presenter.renderForm(
                input: .init(item: item),
                error: nil,
                title: "Edit news category",
                action: NewsAdminRoutes.categoryEdit(RouterPath(id))
                    .description + "/",
                submitLabel: "Save category",
                removeHref: NewsAdminRoutes.categoryRemove(RouterPath(id))
                    .description + "/"
            )
        }
        catch {
            return try await runtime.presenter.renderError(
                error.displayMessage
            )
        }
    }

    func postEditNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let input = try await request.decode(
            as: AdminNewsCategoryFormInput.self,
            context: context
        )
        let action =
            NewsAdminRoutes.categoryEdit(RouterPath(id))
            .description + "/"
        let removeHref =
            NewsAdminRoutes.categoryRemove(RouterPath(id))
            .description + "/"
        if let message = input.validationMessage {
            return try await runtime.presenter
                .renderForm(
                    input: input,
                    error: message,
                    title: "Edit news category",
                    action: action,
                    submitLabel: "Save category",
                    removeHref: removeHref
                )
                .response(from: request, context: context)
        }
        do {
            try await runtime.interactor.update(id: id, input: input.schema)
            return runtime.presenter.renderUpdated(id: id)
        }
        catch {
            return try await runtime.presenter
                .renderForm(
                    input: input,
                    error: error.displayMessage,
                    title: "Edit news category",
                    action: action,
                    submitLabel: "Save category",
                    removeHref: removeHref
                )
                .response(from: request, context: context)
        }
    }
}
