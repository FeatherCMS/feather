import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Edit.Template.Controller {
    struct Default: Interface {
        let routes: Page.Router.Routes
        let buildRuntime: @Sendable (
            Request,
            AuthenticatedRequestContext
        ) -> WebAdminRuntime<
            any Page.Edit.Template.Interactor.Interface,
            any Page.Edit.Template.Presenter.Interface
        >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let pageID = try context.requiredID()
            let metadataID = context.parameters.get(
                "metadataID",
                as: String.self
            ) ?? pageID
            do {
                let model = try await runtime.interactor.load(
                    pageID: pageID,
                    metadataID: metadataID
                )
                return try await runtime.presenter.render(model: model)
            }
            catch {
                return try await runtime.presenter.render(
                    model: .init(
                        pageID: pageID,
                        metadataID: metadataID,
                        templateID: "",
                        templateTitle: "Template unavailable",
                        fields: [],
                        templateData: "{}",
                        error: error.displayMessage,
                        success: nil
                    )
                )
            }
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let pageID = try context.requiredID()
            let metadataID = context.parameters.get(
                "metadataID",
                as: String.self
            ) ?? pageID
            var submittedInput: Page.Edit.Template.Input?
            do {
                let input = try await request.decode(
                    as: Page.Edit.Template.Input.self,
                    context: context
                )
                submittedInput = input
                let model = try await runtime.interactor.save(
                    pageID: pageID,
                    metadataID: metadataID,
                    input: input
                )
                return AdminNotification.redirect(
                    to: routes.templatePath(
                        pageID: pageID,
                        metadataID: model.metadataID
                    ),
                    notification: .init(
                        title: "Saved",
                        message: "Template values saved."
                    )
                )
            }
            catch {
                let model = try await runtime.interactor.load(
                    pageID: pageID,
                    metadataID: metadataID
                )
                return try await runtime.presenter.render(
                    model: .init(
                        pageID: model.pageID,
                        metadataID: model.metadataID,
                        slug: model.slug,
                        templateID: model.templateID,
                        templateTitle: model.templateTitle,
                        fields: model.fields,
                        templateData: model.templateData,
                        error: error.displayMessage,
                        success: nil,
                        formValues: submittedInput?.values
                    )
                )
                .response(from: request, context: context)
            }
        }
    }
}
