import AdminOpenAPI
import Foundation

struct AdminNewsletterSubscribersDirectoryOpenAPIRepository {
    let api: AdminAPI

    func campaigns() async throws -> [AdminNewsletterSubscriberCampaignOption] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterList()
            switch response {
            case .ok(let value): return try value.body.json.map { .init(id: $0.id, name: $0.name) }
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view campaigns.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view campaigns.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func list() async throws -> [AdminNewsletterSubscriberDirectoryItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let newslettersResponse = try await client.contactNewsletterList()
            guard case .ok(let newslettersValue) = newslettersResponse else {
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view newsletters.")
            }
            var grouped: [String: AdminNewsletterSubscriberDirectoryItem] = [:]
            for newsletter in try newslettersValue.body.json {
                let response = try await client.contactNewsletterSubscriberList(
                    path: .init(contactNewsletterId: newsletter.id)
                )
                guard case .ok(let value) = response else { continue }
                for subscriber in try value.body.json {
                    let firstName = subscriber.firstName ?? ""
                    let lastName = subscriber.lastName ?? ""
                    let current = grouped[subscriber.email] ?? .init(email: subscriber.email, name: "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces), newsletters: [])
                    grouped[subscriber.email] = .init(
                        email: current.email,
                        name: current.name.isEmpty ? subscriber.email : current.name,
                        newsletters: current.newsletters + [.init(id: newsletter.id, name: newsletter.name, status: subscriber.status)]
                    )
                }
            }
            return grouped.values.sorted { $0.email.localizedCaseInsensitiveCompare($1.email) == .orderedAscending }
        }
    }
}
