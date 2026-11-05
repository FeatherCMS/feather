import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Edit.Controller {
    struct Default: Interface {
        let routes: Category.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                WebAdminRuntime<
                    any Category.Edit.Interactor.Interface,
                    any Category.Edit.Presenter.Interface
                >

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
                    action: routes.editPath(id),
                    submitLabel: "Save category",
                    moreActions: [
                        .init(
                            label: "Remove",
                            href: routes.removePath(id),
                            style: .destructive
                        )
                    ]
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
                as: Category.Form.Input.self,
                context: context
            )
            let action = routes.editPath(id)
            let moreActions = [
                AdminButton.State(
                    label: "Remove",
                    href: routes.removePath(id),
                    style: .destructive
                )
            ]
            if let message = input.validationMessage {
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        error: message,
                        title: "Edit news category",
                        action: action,
                        submitLabel: "Save category",
                        moreActions: moreActions
                    )
                    .response(from: request, context: context)
            }
            do {
                try await runtime.interactor.update(id: id, input: input)
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
                        moreActions: moreActions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
