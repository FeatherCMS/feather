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

    func resolveRSS() async throws -> AppPublicRSSModel {
        let results = try await events.trigger(
            event: WebRSSContentProvider(),
            using: WebRSSContentEventContext(runtime: runtime)
        )
        let settings = try await repository.publicSiteSettings()
        return .init(
            title: settings.title,
            description: settings.excerpt,
            siteURL: runtime.publicOrigins.siteBaseURL,
            items: results.flatMap { $0 }
        )
    }

    func resolveSitemap() async throws -> AppPublicSitemapModel {
        .init(
            slugs: try await repository.publicMetadataSlugs(),
            baseURL: runtime.publicOrigins.siteBaseURL
        )
    }

    private func resolveResults(
        baseMetadata: PublicContent.Metadata.Base
    ) async throws -> [WebPublicContentProvider.Output] {
        let eventContext = WebPublicContentEventContext<
            PublicContentRuntimeContext
        >(
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
