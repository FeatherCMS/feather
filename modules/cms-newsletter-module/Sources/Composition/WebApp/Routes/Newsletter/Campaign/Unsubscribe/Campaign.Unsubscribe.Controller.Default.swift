import FeatherWebApp
import FeatherWebShared
import Hummingbird
import NewsletterAppAPI
import NewsletterModule
import WebModuleWebApp

extension Campaign.Unsubscribe.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let templateRenderer: any TemplateRenderer
        let route: Campaign.Unsubscribe.Route

        func getConfirmation(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse {
            let action = try route.confirmationAction.path(parameters: [
                "unsubscribeToken": context.requiredParameter(
                    "unsubscribeToken"
                )
            ])
            return try page(
                title: "Unsubscribe from this newsletter?",
                message: "Confirm to stop receiving these emails.",
                action: action,
                button: "Unsubscribe"
            )
        }

        func postOneClick(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            try await unsubscribe(context: context)
            return Response(status: .noContent)
        }

        func postConfirmation(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse {
            try await unsubscribe(context: context)
            return try page(
                title: "You are unsubscribed",
                message: "You will no longer receive this newsletter.",
                action: nil,
                button: nil
            )
        }

        private func unsubscribe(
            context: DefaultRequestContext
        ) async throws {
            let response =
                try await API.Client(
                    environment: environment,
                    requestContext: context
                )
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.appNewsletterCampaignUnsubscribe(
                        body: .json(
                            .init(
                                token: context.requiredParameter(
                                    "unsubscribeToken"
                                )
                            )
                        )
                    )
                }
            guard case .noContent = response else {
                throw HTTPError(.badRequest)
            }
        }

        private func page(
            title: String,
            message: String,
            action: String?,
            button: String?
        ) throws -> WebAppHTMLResponse {
            WebAppHTMLResponse(
                content: try templateRenderer.render(
                    template: "pages/unsubscribe",
                    context: [
                        "title": title,
                        "message": message,
                        "action": action ?? "",
                        "button": button ?? "",
                        "hasAction": action != nil && button != nil,
                    ]
                )
            )
        }
    }
}
