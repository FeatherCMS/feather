import NewsApplication
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Category.Add.Controller {
    struct Default: Interface {
        let routes: Category.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                Category.Add.Runtime

        func getAddCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            try await buildRuntime(request, context).presenter
                .renderForm(
                    input: .init(),
                    error: nil,
                    title: "Add news category",
                    action: routes.add.path,
                    submitLabel: "Add category"
                )
        }

        func postAddCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let input = try await request.decode(
                as: Category.Form.Input.self,
                context: context
            )
            if let message = input.validationMessage {
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        error: message,
                        title: "Add news category",
                        action: routes.add.path,
                        submitLabel: "Add category"
                    )
                    .response(from: request, context: context)
            }
            do {
                try await runtime.interactor.create(input: input.schema)
                return runtime.presenter.renderCreated()
            }
            catch {
                return try await runtime.presenter
                    .renderForm(
                        input: input,
                        error: error.displayMessage,
                        title: "Add news category",
                        action: routes.add.path,
                        submitLabel: "Add category"
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
