import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminNewsletterSubscribersAPIClient {
    let api: NewsletterAdminAPIClient

    func campaigns() async throws -> [AdminNewsletterSubscriberCampaign] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterCampaignList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.id, name: $0.name)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view campaigns."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view campaigns."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func list() async throws -> [AdminNewsletterSubscriberListItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let newslettersResponse = try await client.newsletterCampaignList()
            guard case .ok(let newslettersValue) = newslettersResponse else {
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view newsletters."
                )
            }
            var grouped: [String: AdminNewsletterSubscriberListItem] = [:]
            for newsletter in try newslettersValue.body.json {
                let response = try await client.newsletterSubscriberList(
                    path: .init(newsletterCampaignId: newsletter.id)
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
                                .trimmingCharacters(in: .whitespaces),
                            newsletters: []
                        )
                    grouped[subscriber.id] = .init(
                        id: current.id,
                        email: current.email,
                        name: current.name.isEmpty
                            ? subscriber.email : current.name,
                        newsletters: current.newsletters + [
                            .init(
                                id: newsletter.id,
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

    func bulkRemove(subscriberIds: [String], campaignId: String?) async throws {
        let items = try await list()
        for item in items where subscriberIds.contains(item.id) {
            let newsletters =
                campaignId?.isEmpty == false
                ? item.newsletters.filter { $0.id == campaignId }
                : item.newsletters
            for newsletter in newsletters {
                try await api.withOpenAPIRepositoryErrorMapping { client in
                    _ = try await client.newsletterSubscriberBulkDelete(
                        path: .init(newsletterCampaignId: newsletter.id),
                        body: .json(.init(ids: [item.email], summary: true))
                    )
                }
            }
        }
    }
}
