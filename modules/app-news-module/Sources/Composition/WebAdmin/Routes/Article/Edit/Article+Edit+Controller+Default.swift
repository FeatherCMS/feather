import NewsApplication
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Article.Edit.Controller {
    struct Default: Interface {
        let routes: Article.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                WebAdminRuntime<
                    any Article.Edit.Interactor.Interface,
                    any Article.Edit.Presenter.Interface
                >

        func getEditNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            do {
                let item = try await runtime.interactor.get(id: id)
                let categories =
                    (try? await runtime.interactor.categories()) ?? []
                return try await runtime.presenter.renderForm(
                    input: .init(item: item),
                    categories: categories,
                    error: nil,
                    title: "Edit news article",
                    action: routes.editPath(id),
                    submitLabel: "Save article",
                    removeHref: routes.removePath(id)
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
                as: Article.Form.Input.self,
                context: context
            )
            let action = routes.editPath(id)
            let removeHref = routes.removePath(id)
            let categories =
                (try? await runtime.interactor.categories()) ?? []
            if let message = input.validationMessage {
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        categories: categories,
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
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        categories: categories,
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
}
