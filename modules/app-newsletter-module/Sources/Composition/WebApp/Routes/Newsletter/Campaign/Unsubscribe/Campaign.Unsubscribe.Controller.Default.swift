import FeatherWebApp
import FeatherWebShared
import Hummingbird
import NewsletterAppAPI
import NewsletterModule
import WebModuleWebApp

extension Campaign.Unsubscribe.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let route: Campaign.Unsubscribe.Route

        func getConfirmation(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse {
            let action = try route.confirmationAction.path(parameters: [
                "unsubscribeToken": context.requiredParameter(
                    "unsubscribeToken"
                ),
            ])
            return page(
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
            return page(
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
        ) -> WebAppHTMLResponse {
            let form =
                if let action, let button {
                    "<form action=\"\(action)\" method=\"post\"><button type=\"submit\">\(button)</button></form>"
                }
                else {
                    ""
                }
            return WebAppHTMLResponse(
                content: """
                    <!doctype html>
                    <html lang="en">
                    <head>
                      <meta charset="utf-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1">
                      <title>\(title)</title>
                      <style>
                        :root { color-scheme: light dark; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
                        * { box-sizing: border-box; }
                        body { margin: 0; min-height: 100vh; color: #111827; background: #f8fafc; }
                        main { display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 32px 20px; }
                        section { width: 100%; max-width: 440px; padding: 32px; border: 1px solid #d8dee7; border-radius: 20px; background: #fff; box-shadow: 0 12px 26px 2px rgba(17, 24, 39, .08); }
                        h1 { margin: 0 0 8px; font-size: 1.5rem; }
                        p { margin: 0; color: #374151; }
                        form { margin-top: 24px; }
                        button { padding: 10px 16px; border: 1px solid #4b2780; border-radius: 999px; color: #fff; background: #6536ab; font: inherit; font-weight: 700; cursor: pointer; }
                        @media (prefers-color-scheme: dark) { body { color: #f7fbff; background: #202023; } section { border-color: #2b2b2e; background: #19191b; } p { color: #e0dde5; } }
                      </style>
                    </head>
                    <body><main><section><h1>\(title)</h1><p>\(message)</p>\(form)</section></main></body>
                    </html>
                    """
            )
        }
    }
}
