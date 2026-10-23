import FeatherValidation
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import NewsletterAppAPI
import NewsletterWebShared
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

struct AppNewsletterCampaignSubscriptionDefaultController:
    AppNewsletterCampaignSubscriptionController
{
    let apiBuilder: NewsletterAppAPIBuilder
    let route: NewsletterSubscriptionRoute
    let turnstileVerifier: (any TurnstileVerifier)?
    func subscribe(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let campaignId = try context.requiredParameter(route.parameterName)
        let decoded = try await request.decode(
            as: TurnstileDecoded<AppNewsletterCampaignSubscriptionForm>.self,
            context: context
        )
        let form = decoded.data
        guard
            FormSubmissionNonce.matches(
                formValue: form.nonce,
                cookieValue: request.cookies[
                    FormSubmissionNonce.cookieName
                ]?
                .value
            )
        else {
            throw HTTPError(.forbidden)
        }
        do {
            if let turnstileVerifier,
                try await !turnstileVerifier.verify(
                    token: decoded.token
                )
            {
                throw HTTPError(.forbidden)
            }
            let response = try await apiBuilder.makeNewsletterApp(context)
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.appNewsletterCampaignSubscribe(
                        path: .init(newsletterCampaignKey: campaignId),
                        body: .json(.init(email: form.email))
                    )
                }
            guard case .noContent = response else {
                throw HTTPError(.badRequest)
            }
            if let redirectURL = form.redirect.flatMap({ value -> String? in
                guard
                    value.hasPrefix("/"),
                    !value.hasPrefix("//"),
                    !value.contains("\\"),
                    !value.contains("://"),
                    value.unicodeScalars.allSatisfy({
                        !CharacterSet.controlCharacters.contains($0)
                    })
                else {
                    return nil
                }
                return value
            }) {
                return Response(
                    status: .seeOther,
                    headers: [.location: redirectURL]
                )
            }
            var redirectURL: String?
            if let referer = request.headers[.referer],
                let refererComponents = URLComponents(string: referer),
                let refererHost = refererComponents.host,
                let refererScheme = refererComponents.scheme?.lowercased(),
                ["http", "https"].contains(refererScheme),
                refererComponents.user == nil,
                refererComponents.password == nil,
                let requestHost = request.head.authority,
                let requestComponents = URLComponents(
                    string: "http://\(requestHost)"
                ),
                refererHost.caseInsensitiveCompare(
                    requestComponents.host ?? ""
                ) == .orderedSame,
                refererComponents.port == requestComponents.port
            {
                let path =
                    refererComponents.percentEncodedPath.isEmpty
                    ? "/"
                    : refererComponents.percentEncodedPath
                if path.hasPrefix("/"),
                    !path.hasPrefix("//"),
                    !path.contains("\\")
                {
                    var components = URLComponents()
                    components.percentEncodedPath = path
                    components.percentEncodedFragment =
                        refererComponents.percentEncodedFragment
                    var queryItems = (refererComponents.queryItems ?? [])
                        .filter {
                            ![
                                FormSubmissionFeedback.sourceQueryKey,
                                FormSubmissionFeedback.keyQueryKey,
                                FormSubmissionFeedback.statusQueryKey,
                            ]
                            .contains($0.name)
                        }
                    queryItems.append(
                        contentsOf: [
                            .init(
                                name: FormSubmissionFeedback.sourceQueryKey,
                                value: FormSubmissionFeedback.Source
                                    .newsletter.rawValue
                            ),
                            .init(
                                name: FormSubmissionFeedback.keyQueryKey,
                                value: campaignId
                            ),
                            .init(
                                name: FormSubmissionFeedback.statusQueryKey,
                                value: FormSubmissionFeedback.Status.success
                                    .rawValue
                            ),
                        ]
                    )
                    components.queryItems = queryItems
                    redirectURL = components.string
                }
            }
            if redirectURL == nil {
                var components = URLComponents()
                components.path = "/"
                components.queryItems = [
                    .init(
                        name: FormSubmissionFeedback.sourceQueryKey,
                        value: FormSubmissionFeedback.Source.newsletter
                            .rawValue
                    ),
                    .init(
                        name: FormSubmissionFeedback.keyQueryKey,
                        value: campaignId
                    ),
                    .init(
                        name: FormSubmissionFeedback.statusQueryKey,
                        value: FormSubmissionFeedback.Status.success.rawValue
                    ),
                ]
                redirectURL = components.string
            }
            return Response(
                status: .seeOther,
                headers: [.location: redirectURL ?? "/"]
            )
        }
        catch {
            var redirectURL: String?
            if let referer = request.headers[.referer],
                let refererComponents = URLComponents(string: referer),
                let refererHost = refererComponents.host,
                let refererScheme = refererComponents.scheme?.lowercased(),
                ["http", "https"].contains(refererScheme),
                refererComponents.user == nil,
                refererComponents.password == nil,
                let requestHost = request.head.authority,
                let requestComponents = URLComponents(
                    string: "http://\(requestHost)"
                ),
                refererHost.caseInsensitiveCompare(
                    requestComponents.host ?? ""
                ) == .orderedSame,
                refererComponents.port == requestComponents.port
            {
                let path =
                    refererComponents.percentEncodedPath.isEmpty
                    ? "/"
                    : refererComponents.percentEncodedPath
                if path.hasPrefix("/"),
                    !path.hasPrefix("//"),
                    !path.contains("\\")
                {
                    var components = URLComponents()
                    components.percentEncodedPath = path
                    components.percentEncodedFragment =
                        refererComponents.percentEncodedFragment
                    var queryItems = (refererComponents.queryItems ?? [])
                        .filter {
                            ![
                                FormSubmissionFeedback.sourceQueryKey,
                                FormSubmissionFeedback.keyQueryKey,
                                FormSubmissionFeedback.statusQueryKey,
                            ]
                            .contains($0.name)
                        }
                    queryItems.append(
                        contentsOf: [
                            .init(
                                name: FormSubmissionFeedback.sourceQueryKey,
                                value: FormSubmissionFeedback.Source
                                    .newsletter.rawValue
                            ),
                            .init(
                                name: FormSubmissionFeedback.keyQueryKey,
                                value: campaignId
                            ),
                            .init(
                                name: FormSubmissionFeedback.statusQueryKey,
                                value: FormSubmissionFeedback.Status.failure
                                    .rawValue
                            ),
                        ]
                    )
                    components.queryItems = queryItems
                    redirectURL = components.string
                }
            }
            if redirectURL == nil {
                var components = URLComponents()
                components.path = "/"
                components.queryItems = [
                    .init(
                        name: FormSubmissionFeedback.sourceQueryKey,
                        value: FormSubmissionFeedback.Source.newsletter
                            .rawValue
                    ),
                    .init(
                        name: FormSubmissionFeedback.keyQueryKey,
                        value: campaignId
                    ),
                    .init(
                        name: FormSubmissionFeedback.statusQueryKey,
                        value: FormSubmissionFeedback.Status.failure.rawValue
                    ),
                ]
                redirectURL = components.string
            }
            return Response(
                status: .seeOther,
                headers: [.location: redirectURL ?? "/"]
            )
        }
    }
}
