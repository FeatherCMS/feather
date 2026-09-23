import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebAppAPI
import WebContracts

struct AppPublicContentDefaultInteractor: AppPublicContentInteractor {
    let repository: any AppPublicContentRepository
    let events: any EventPublisher
    let runtime: PublicContentRuntimeContext

    func resolve(
        slug: String
    ) async throws -> AppPublicContentModel {
        let metadata = try await repository.resolveWebRoute(slug: slug)
        let baseMetadata: PublicContent.Metadata.Base
        let status: HTTPResponse.Status

        if let metadata {
            baseMetadata = .init(
                referenceType: metadata.referenceType,
                referenceId: metadata.referenceId,
                slug: metadata.slug,
                template: metadata.template
            )
            status = .ok
        }
        else {
            let template = slug.isEmpty ? "home" : "not-found"
            baseMetadata = .init(
                referenceType: "",
                referenceId: "",
                slug: slug,
                template: template
            )
            status = slug.isEmpty ? .ok : .notFound
        }

        let results = try await resolveResults(
            baseMetadata: baseMetadata
        )
        return .init(
            metadata: baseMetadata,
            results: results,
            status: status
        )
    }

    private func resolveResults(
        baseMetadata: PublicContent.Metadata.Base
    ) async throws -> [WebPublicContentProvider.Output] {
        let eventContext = WebPublicContentEventContext<PublicContentRuntimeContext>(
            baseMetadata: baseMetadata,
            runtime: runtime
        )
        let results = try await events.trigger(
            event: WebPublicContentProvider(),
            using: eventContext
        )
        return results
    }
}
