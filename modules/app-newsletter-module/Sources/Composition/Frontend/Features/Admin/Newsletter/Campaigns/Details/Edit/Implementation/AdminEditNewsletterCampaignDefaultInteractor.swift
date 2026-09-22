import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignDefaultInteractor:
    AdminEditNewsletterCampaignInteractor
{
    let repository: AdminEditNewsletterCampaignOpenAPIRepository
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        do {
            return try await repository.get(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }
    func update(
        id: String,
        newKey: String,
        name: String,
        fromEmail: String
    ) async throws {
        do {
            try await repository.update(
                id: id,
                newKey: newKey,
                name: name,
                fromEmail: fromEmail
            )
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminEditNewsletterCampaignError {
        switch error {
        case .notFound:
            .notFound
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict:
            .conflict
        case .failure, .transport:
            .unavailable
        }
    }
}
