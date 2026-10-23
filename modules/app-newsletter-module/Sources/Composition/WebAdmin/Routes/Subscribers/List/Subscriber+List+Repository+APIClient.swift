import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List.Repository {
    struct APIClient {
        let api: API.Client

        func campaigns() async throws -> [Subscriber.List.Model.Campaign] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignList()
                switch response {
                case .ok(let value):
                    return try value.body.json.map {
                        .init(id: $0.key, name: $0.name)
                    }
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

        func list() async throws -> [Subscriber.List.Model.Item] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let newslettersResponse =
                    try await client.newsletterCampaignList()
                guard case .ok(let newslettersValue) = newslettersResponse
                else {
                    throw OpenAPIRepositoryError.forbidden
                }
                var grouped: [String: Subscriber.List.Model.Item] = [:]
                for newsletter in try newslettersValue.body.json {
                    let response = try await client.newsletterSubscriberList(
                        path: .init(newsletterCampaignKey: newsletter.key)
                    )
                    guard case .ok(let value) = response else { continue }
                    for subscriber in try value.body.json {
                        let firstName = subscriber.firstName ?? ""
                        let lastName = subscriber.lastName ?? ""
                        let current =
                            grouped[subscriber.id]
                            ?? .init(
                                id: subscriber.id,
                                email: subscriber.email,
                                name: "\(firstName) \(lastName)"
                                    .whitespaceTrimmed,
                                newsletters: []
                            )
                        grouped[subscriber.id] = .init(
                            id: current.id,
                            email: current.email,
                            name: current.name.isEmpty
                                ? subscriber.email : current.name,
                            newsletters: current.newsletters + [
                                .init(
                                    id: newsletter.key,
                                    name: newsletter.name,
                                    status: subscriber.status
                                )
                            ]
                        )
                    }
                }
                return grouped.values.sorted {
                    $0.email.localizedCaseInsensitiveCompare($1.email)
                        == .orderedAscending
                }
            }
        }

        func get(id: String) async throws -> Subscriber.List.Model.Item {
            guard let item = try await list().first(where: { $0.id == id })
            else {
                throw OpenAPIRepositoryError.notFound
            }
            return item
        }

        func remove(subscriberIds: [String], campaignId: String?) async throws {
            let items = try await list()
            for item in items where subscriberIds.contains(item.id) {
                let newsletters =
                    campaignId?.isEmpty == false
                    ? item.newsletters.filter { $0.id == campaignId }
                    : item.newsletters
                for newsletter in newsletters {
                    try await api.withOpenAPIRepositoryErrorMapping { client in
                        _ = try await client.newsletterSubscriberRemove(
                            path: .init(newsletterCampaignKey: newsletter.id),
                            body: .json(
                                .init(
                                    ids: [item.email]
                                )
                            )
                        )
                    }
                }
            }
        }
    }
}
