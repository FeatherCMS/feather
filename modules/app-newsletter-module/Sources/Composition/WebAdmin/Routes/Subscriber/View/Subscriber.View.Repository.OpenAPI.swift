import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Subscriber.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(id: String) async throws -> Subscriber.View.Model {
            var encodedEmail =
                id
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            while encodedEmail.count.isMultiple(of: 4) == false {
                encodedEmail.append("=")
            }
            guard
                let emailData = Data(base64Encoded: encodedEmail),
                let email = String(data: emailData, encoding: .utf8)
            else {
                throw OpenAPIRepositoryError.notFound
            }

            return try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberQuery(
                    body: .json(
                        .init(
                            page: .init(size: 1, number: 1),
                            filters: .init(email: email)
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    guard
                        let subscriber = try value.body.json.data.items
                            .first(where: { $0.email == email })
                    else {
                        throw OpenAPIRepositoryError.notFound
                    }
                    return Subscriber.View.Model(
                        id: Data(subscriber.email.utf8)
                            .base64EncodedString()
                            .replacingOccurrences(of: "+", with: "-")
                            .replacingOccurrences(of: "/", with: "_")
                            .replacingOccurrences(of: "=", with: ""),
                        email: subscriber.email,
                        name: subscriber.name,
                        newsletters: subscriber.memberships.map {
                            Subscriber.View.Model.Newsletter(
                                id: $0.campaignKey,
                                name: $0.campaignName,
                                status: $0.status
                            )
                        }
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
