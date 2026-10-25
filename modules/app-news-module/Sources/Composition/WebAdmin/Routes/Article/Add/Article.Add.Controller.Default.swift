import NewsApplication
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Article.Add.Controller {
    struct Default: Interface {
        let routes: Article.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                WebAdminRuntime<
                    any Article.Add.Interactor.Interface,
                    any Article.Add.Presenter.Interface
                >

        func getAddNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let categories = (try? await runtime.interactor.categories()) ?? []
            return try await runtime.presenter.renderForm(
                input: .init(),
                categories: categories,
                error: nil,
                title: "Add news article",
                action: routes.add.path,
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
                as: Article.Form.Input.self,
                context: context
            )
            let categories = (try? await runtime.interactor.categories()) ?? []
            if let message = input.validationMessage {
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        categories: categories,
                        error: message,
                        title: "Add news article",
                        action: routes.add.path,
                        submitLabel: "Add article",
                        removeHref: nil
                    )
                    .response(from: request, context: context)
            }
            do {
                try await runtime.interactor.create(input: input)
                return runtime.presenter.renderCreated()
            }
            catch {
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        categories: categories,
                        error: error.displayMessage,
                        title: "Add news article",
                        action: routes.add.path,
                        submitLabel: "Add article",
                        removeHref: nil
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
