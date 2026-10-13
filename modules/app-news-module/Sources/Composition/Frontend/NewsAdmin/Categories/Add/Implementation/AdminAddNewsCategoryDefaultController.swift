import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminAddNewsCategoryDefaultController: AdminAddNewsCategoryController {
    let buildRuntime: AdminNewsCategoryRuntimeBuilder

    func getAddNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        try await buildRuntime(request, context).presenter
            .renderForm(
                input: .init(),
                error: nil,
                title: "Add news category",
                action: NewsAdminRoutes.categoryAdd().description + "/",
                submitLabel: "Add category",
                removeHref: nil
            )
    }

    func postAddNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let input = try await request.decode(
            as: AdminNewsCategoryFormInput.self,
            context: context
        )
        if let message = input.validationMessage {
            return try await runtime.presenter
                .renderForm(
                    input: input,
                    error: message,
                    title: "Add news category",
                    action: NewsAdminRoutes.categoryAdd().description + "/",
                    submitLabel: "Add category",
                    removeHref: nil
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
                    action: NewsAdminRoutes.categoryAdd().description + "/",
                    submitLabel: "Add category",
                    removeHref: nil
                )
                .response(from: request, context: context)
        }
    }
}
