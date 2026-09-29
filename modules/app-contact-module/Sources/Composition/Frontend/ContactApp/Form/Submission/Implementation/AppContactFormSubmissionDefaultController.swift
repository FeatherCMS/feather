import ContactAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AppContactFormSubmissionDefaultController:
    AppContactFormSubmissionController
{
    let apiBuilder: ContactAPIBuilder

    func submit(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let formKey = try context.requiredParameter("formKey")
        let form = try await request.decode(
            as: AppContactFormSubmissionForm.self,
            context: context
        )
        guard WebFormSubmissionNonce.matches(
            formValue: form.nonce,
            cookieValue: request.cookies[
                WebFormSubmissionNonce.cookieName
            ]?.value
        ) else {
            throw HTTPError(.forbidden)
        }
        do {
            let response = try await apiBuilder.makeContactApp(context)
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.appContactFormSubmission(
                        path: .init(contactFormKey: formKey),
                        body: .json(
                            .init(
                                values: .init(
                                    additionalProperties: form.values
                                )
                            )
                        )
                    )
                }
            guard case .created(let value) = response else {
                throw HTTPError(.badRequest)
            }
            let configuredRedirectURL = try value.body.json.redirectUrl
                ?? form.redirect.flatMap { value in
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
                }
            if let configuredRedirectURL {
                return Response(
                    status: .seeOther,
                    headers: [.location: configuredRedirectURL]
                )
            }
            var redirectURL: String?
            if
                let referer = request.headers[.referer],
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
                let path = refererComponents.percentEncodedPath.isEmpty
                    ? "/"
                    : refererComponents.percentEncodedPath
                if
                    path.hasPrefix("/"),
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
                                WebFormSubmissionFeedback.sourceQueryKey,
                                WebFormSubmissionFeedback.keyQueryKey,
                                WebFormSubmissionFeedback.statusQueryKey,
                            ].contains($0.name)
                        }
                    queryItems.append(
                        contentsOf: [
                            .init(
                                name: WebFormSubmissionFeedback.sourceQueryKey,
                                value: WebFormSubmissionFeedback.Source.contact.rawValue
                            ),
                            .init(
                                name: WebFormSubmissionFeedback.keyQueryKey,
                                value: formKey
                            ),
                            .init(
                                name: WebFormSubmissionFeedback.statusQueryKey,
                                value: WebFormSubmissionFeedback.Status.success.rawValue
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
                        name: WebFormSubmissionFeedback.sourceQueryKey,
                        value: WebFormSubmissionFeedback.Source.contact.rawValue
                    ),
                    .init(
                        name: WebFormSubmissionFeedback.keyQueryKey,
                        value: formKey
                    ),
                    .init(
                        name: WebFormSubmissionFeedback.statusQueryKey,
                        value: WebFormSubmissionFeedback.Status.success.rawValue
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
            if
                let referer = request.headers[.referer],
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
                let path = refererComponents.percentEncodedPath.isEmpty
                    ? "/"
                    : refererComponents.percentEncodedPath
                if
                    path.hasPrefix("/"),
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
                                WebFormSubmissionFeedback.sourceQueryKey,
                                WebFormSubmissionFeedback.keyQueryKey,
                                WebFormSubmissionFeedback.statusQueryKey,
                            ].contains($0.name)
                        }
                    queryItems.append(
                        contentsOf: [
                            .init(
                                name: WebFormSubmissionFeedback.sourceQueryKey,
                                value: WebFormSubmissionFeedback.Source.contact.rawValue
                            ),
                            .init(
                                name: WebFormSubmissionFeedback.keyQueryKey,
                                value: formKey
                            ),
                            .init(
                                name: WebFormSubmissionFeedback.statusQueryKey,
                                value: WebFormSubmissionFeedback.Status.failure.rawValue
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
                        name: WebFormSubmissionFeedback.sourceQueryKey,
                        value: WebFormSubmissionFeedback.Source.contact.rawValue
                    ),
                    .init(
                        name: WebFormSubmissionFeedback.keyQueryKey,
                        value: formKey
                    ),
                    .init(
                        name: WebFormSubmissionFeedback.statusQueryKey,
                        value: WebFormSubmissionFeedback.Status.failure.rawValue
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
