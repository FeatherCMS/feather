import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminAddNewsArticleDefaultController: AdminAddNewsArticleController {
    let buildRuntime: AdminNewsArticleRuntimeBuilder

    func getAddNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        return try await AdminNewsArticleFormRenderer()
            .render(
                input: .init(),
                runtime: runtime,
                error: nil,
                title: "Add news article",
                action: NewsAdminRoutes.articleAdd().description + "/",
                submitLabel: "Add article",
                removeHref: nil
            )
    }

    func postAddNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let input = try await request.decode(
            as: AdminNewsArticleFormInput.self,
            context: context
        )
        if let message = input.validationMessage {
            return try await AdminNewsArticleFormRenderer()
                .render(
                    input: input,
                    runtime: runtime,
                    error: message,
                    title: "Add news article",
                    action: NewsAdminRoutes.articleAdd().description + "/",
                    submitLabel: "Add article",
                    removeHref: nil
                )
                .response(from: request, context: context)
        }
        do {
            try await runtime.interactor.create(input: input.schema)
            return runtime.presenter.renderCreated()
        }
        catch {
            return try await AdminNewsArticleFormRenderer()
                .render(
                    input: input,
                    runtime: runtime,
                    error: error.displayMessage,
                    title: "Add news article",
                    action: NewsAdminRoutes.articleAdd().description + "/",
                    submitLabel: "Add article",
                    removeHref: nil
                )
                .response(from: request, context: context)
        }
    }
}
