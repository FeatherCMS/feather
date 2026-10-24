import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add.Controller {
    struct Default: Interface {
        let routes: Subscriber.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Subscriber.Add.Interactor.Interface,
                any Subscriber.Add.Presenter.Interface
            >

        func get(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            do {
                return try await presenter.render(
                    model: try await interactor.get(),
                    isAdded: request.hasQueryFlag("added"),
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await presenter.render(
                    model: .init(
                        email: "",
                        firstName: "",
                        lastName: "",
                        selectedCampaignIds: [],
                        campaigns: [],
                        error: error.displayMessage
                    ),
                    isAdded: false,
                    permissions: context.currentUserPermissions
                )
            }
        }

        func post(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let form = try await request.decode(
                as: Subscriber.Add.Form.self,
                context: context
            )
            do {
                let model = try await interactor.post(form: form)
                if model.error == nil {
                    return AdminNotificationFlash.redirect(
                        to: routes.list.path,
                        notification: .init(
                            title: "Added",
                            message: "Subscriber added successfully."
                        )
                    )
                }
                return
                    try await presenter.render(
                        model: model,
                        isAdded: false,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                let model =
                    (try? await interactor.get())
                    ?? .init(
                        email: form.email,
                        firstName: form.firstName,
                        lastName: form.lastName,
                        selectedCampaignIds: form.selectedCampaignIds,
                        campaigns: [],
                        error: error.displayMessage
                    )
                return
                    try await presenter.render(
                        model: .init(
                            email: form.email,
                            firstName: form.firstName,
                            lastName: form.lastName,
                            selectedCampaignIds: form.selectedCampaignIds,
                            campaigns: model.campaigns,
                            error: error.displayMessage
                        ),
                        isAdded: false,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
