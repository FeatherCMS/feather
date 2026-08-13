import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterSubscriberDefaultController:
    AdminAddNewsletterSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddNewsletterSubscriberInteractor,
            presenter: any AdminAddNewsletterSubscriberPresenter
        )

    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        do {
            return presenter.render(
                model: try await interactor.get(),
                isAdded: request.hasQueryFlag("added"),
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
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

    func post(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let form = try await request.decode(
            as: AdminAddNewsletterSubscriberForm.self,
            context: context
        )
        do {
            let model = try await interactor.post(form: form)
            if model.error == nil {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminToastRedirect.location(
                            defaultPath: "/admin/newsletters/subscribers/",
                            title: "Added",
                            message: "Subscriber added successfully."
                        )
                    ]
                )
            }
            return
                try presenter.render(
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
                try presenter.render(
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
