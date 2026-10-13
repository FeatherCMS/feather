import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminEditNewsArticleDefaultController: AdminEditNewsArticleController {
    let buildRuntime: AdminNewsArticleRuntimeBuilder

    func getEditNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let item = try await runtime.interactor.get(id: id)
            return try await AdminNewsArticleFormRenderer()
                .render(
                    input: .init(item: item),
                    runtime: runtime,
                    error: nil,
                    title: "Edit news article",
                    action: NewsAdminRoutes.articleEdit(RouterPath(id))
                        .description + "/",
                    submitLabel: "Save article",
                    removeHref: NewsAdminRoutes.articleRemove(RouterPath(id))
                        .description + "/"
                )
        }
        catch {
            return try await runtime.presenter.renderError(
                error.displayMessage
            )
        }
    }

    func postEditNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let input = try await request.decode(
            as: AdminNewsArticleFormInput.self,
            context: context
        )
        let action =
            NewsAdminRoutes.articleEdit(RouterPath(id))
            .description + "/"
        let removeHref =
            NewsAdminRoutes.articleRemove(RouterPath(id))
            .description + "/"
        if let message = input.validationMessage {
            return try await AdminNewsArticleFormRenderer()
                .render(
                    input: input,
                    runtime: runtime,
                    error: message,
                    title: "Edit news article",
                    action: action,
                    submitLabel: "Save article",
                    removeHref: removeHref
                )
                .response(from: request, context: context)
        }
        do {
            try await runtime.interactor.update(id: id, input: input.schema)
            return runtime.presenter.renderUpdated(id: id)
        }
        catch {
            return try await AdminNewsArticleFormRenderer()
                .render(
                    input: input,
                    runtime: runtime,
                    error: error.displayMessage,
                    title: "Edit news article",
                    action: action,
                    submitLabel: "Save article",
                    removeHref: removeHref
                )
                .response(from: request, context: context)
        }
    }
}
