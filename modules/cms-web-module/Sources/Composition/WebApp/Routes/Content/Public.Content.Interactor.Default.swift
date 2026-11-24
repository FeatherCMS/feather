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
            let siteSettings = metadata.map {
                WebModule.Public.SiteSettings(
                    title: $0.siteSettings.title,
                    excerpt: $0.siteSettings.excerpt,
                    locale: $0.siteSettings.locale,
                    timezone: $0.siteSettings.timezone,
                    noIndex: $0.siteSettings.noIndex,
                    logo: $0.siteSettings.logo,
                    logoDark: $0.siteSettings.logoDark,
                    metaImage: $0.siteSettings.metaImage,
                    primaryColor: $0.siteSettings.primaryColor,
                    secondaryColor: $0.siteSettings.secondaryColor,
                    tertiaryColor: $0.siteSettings.tertiaryColor,
                    primaryFont: $0.siteSettings.primaryFont,
                    secondaryFont: $0.siteSettings.secondaryFont,
                    trailingSlashBehavior: $0.siteSettings.trailingSlashBehavior.rawValue,
                    css: $0.siteSettings.css,
                    js: $0.siteSettings.js
                )
            }
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

            let results = try await resolveResults(
                baseMetadata: baseMetadata,
                siteSettings: siteSettings
            )
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
            baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base,
            siteSettings: WebModule.Public.SiteSettings?
        ) async throws -> [WebModule.Public.Content.Event.Provider.Output] {
            let eventContext = WebModule.Public.Content.Event.Context<
                PublicContentRuntimeContext
            >(
                baseMetadata: baseMetadata,
                runtime: runtime,
                siteSettings: siteSettings
            )
            let results = try await events.trigger(
                event: WebModule.Public.Content.Event.Provider(),
                using: eventContext
            )
            return results
        }
    }
}
