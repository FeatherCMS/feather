import FeatherModuleKit
import FeatherWebApp
import FeatherWebShared
import Hummingbird
import WebAppAPI
import WebDomain
import WebModule

extension Public.Content.Interactor {
    struct Default: Interface {
        let repository: any Public.Content.Repository.Interface
        let events: any EventPublisher
        let runtime: PublicContentRuntimeContext

        func resolve(
            slug: String
        ) async throws -> Public.Content.Model {
            let metadata = try await repository.resolveWebRoute(slug: slug)
            let baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base
            let status: HTTPResponse.Status

            if let metadata {
                let redirectToConfiguredHomePage =
                    slug.isEmpty && !metadata.slug.isEmpty
                baseMetadata = .init(
                    referenceType: metadata.referenceType,
                    referenceId: metadata.referenceId,
                    slug: metadata.slug,
                    template: metadata.template
                )
                status = redirectToConfiguredHomePage
                    ? .movedPermanently
                    : .ok
            }
            else {
                baseMetadata = .init(
                    referenceType: "",
                    referenceId: "",
                    slug: slug,
                    template: "not-found"
                )
                status = .notFound
            }

            let results: [WebModule.Public.Content.Event.Provider.Output]
            if status == .ok {
                results = try await resolveResults(
                    baseMetadata: baseMetadata
                )
            }
            else {
                results = []
            }
            return .init(
                metadata: baseMetadata,
                results: results,
                status: status,
                canonicalPath: metadata?.canonicalPath ?? "/"
            )
        }

        func resolveRSS() async throws -> Public.RSS.Model {
            let results = try await events.trigger(
                event: WebModule.Public.RSS.Event.Provider(),
                using: WebModule.Public.RSS.Event.Context(runtime: runtime)
            )
            let settings = try await repository.publicSiteSettings()
            return .init(
                title: settings.title,
                description: settings.excerpt,
                siteURL: runtime.publicOrigins.siteBaseURL,
                items: results.flatMap { $0 }
            )
        }

        func resolveSitemap() async throws -> Public.Sitemap.Model {
            let settings = try await repository.publicSiteSettings()
            return .init(
                slugs: try await repository.publicMetadataSlugs(),
                baseURL: runtime.publicOrigins.siteBaseURL,
                trailingSlashBehavior: Settings.TrailingSlashBehavior(
                    rawValue: settings.trailingSlashBehavior.rawValue
                ) ?? .enforce
            )
        }

        private func resolveResults(
            baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base
        ) async throws -> [WebModule.Public.Content.Event.Provider.Output] {
            let eventContext = WebModule.Public.Content.Event.Context<
                PublicContentRuntimeContext
            >(
                baseMetadata: baseMetadata,
                runtime: runtime
            )
            let results = try await events.trigger(
                event: WebModule.Public.Content.Event.Provider(),
                using: eventContext
            )
            return results
        }
    }
}
