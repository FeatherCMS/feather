import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterSubscriberDefaultController:
    AdminAddNewsletterSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminAddNewsletterSubscriberInteractor,
            any AdminAddNewsletterSubscriberPresenter
        >

    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
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
        let __runtimeBuild2 = buildRuntime(request, context)
        let interactor = __runtimeBuild2.interactor
        let presenter = __runtimeBuild2.presenter
        let form = try await request.decode(
            as: AdminAddNewsletterSubscriberForm.self,
            context: context
        )
        do {
            let model = try await interactor.post(form: form)
            if model.error == nil {
                return AdminNotificationFlash.redirect(
                    to: NewsletterAdminRoutes.subscribers.description,
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
