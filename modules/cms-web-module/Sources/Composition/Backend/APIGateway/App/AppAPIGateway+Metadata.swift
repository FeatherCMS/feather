public import WebAppAPI
import WebApplication
import WebDomain
import WebModule

extension AppAPIGateway {
    public func metadataGet(
        _ input: Operations.MetadataGet.Input
    ) async throws -> Operations.MetadataGet.Output {
        let settings = try await useCases.makeDetailPublicSettings().execute()
        guard let metadata = try await resolveMetadata(
            slug: input.path.slug,
            settings: settings
        )
        else {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Page not found",
                                reason:
                                    "No published page exists for this route."
                            )
                        )
                    )
                )
            )
        }
        return .ok(.init(body: .json(metadata)))
    }

    public func metadataRootGet(
        _ input: Operations.MetadataRootGet.Input
    ) async throws -> Operations.MetadataRootGet.Output {
        let settings = try await useCases.makeDetailPublicSettings().execute()
        let metadata: Components.Schemas.MetadataSchema?
        if let homePageId = settings.homePageId, !homePageId.isEmpty {
            do {
                let page = try await useCases.makeDetailPublicPageByID()
                    .execute(input: .init(id: homePageId))
                let canonicalPath: String
                if page.metadata.slug.isEmpty {
                    canonicalPath = "/"
                }
                else if settings.trailingSlashBehavior == .enforce {
                    canonicalPath = "/\(page.metadata.slug)/"
                }
                else {
                    canonicalPath = "/\(page.metadata.slug)"
                }
                metadata = .init(
                    referenceType: page.metadata.referenceType,
                    referenceId: page.metadata.referenceID,
                    slug: page.metadata.slug,
                    canonicalPath: canonicalPath,
                    siteSettings: map(settings),
                    template: page.metadata.template
                )
            }
            catch is WebApplication.Public.Page.Detail.Error {
                metadata = nil
            }
        }
        else {
            metadata = try await resolveMetadata(
                slug: "",
                settings: settings
            )
        }
        guard let metadata else {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Page not found",
                                reason:
                                    "No published page exists for this route."
                            )
                        )
                    )
                )
            )
        }
        return .ok(.init(body: .json(metadata)))
    }

    private func resolveMetadata(
        slug: String,
        settings: Settings.Public.Detail.Output
    ) async throws -> Components.Schemas.MetadataSchema? {
        do {
            let route = try await useCases.makeResolveWebRoute()
                .execute(input: WebRoute.Resolve.Input(slug: slug))
            let canonicalPath: String
            if route.slug.isEmpty {
                canonicalPath = "/"
            }
            else if settings.trailingSlashBehavior == .enforce {
                canonicalPath = "/\(route.slug)/"
            }
            else {
                canonicalPath = "/\(route.slug)"
            }
            return .init(
                referenceType: route.referenceType,
                referenceId: route.referenceID,
                slug: route.slug,
                canonicalPath: canonicalPath,
                siteSettings: map(settings),
                template: route.template
            )
        }
        catch is WebApplication.WebRoute.Resolve.Error {
            return nil
        }
    }

    private func map(
        _ settings: Settings.Public.Detail.Output
    ) -> Components.Schemas.SiteSettingsSchema {
        .init(
            title: settings.title,
            excerpt: settings.excerpt,
            locale: settings.locale,
            timezone: settings.timezone,
            noIndex: settings.noIndex,
            logo: settings.logo,
            logoDark: settings.logoDark,
            metaImage: settings.metaImage,
            primaryColor: settings.primaryColor,
            secondaryColor: settings.secondaryColor,
            tertiaryColor: settings.tertiaryColor,
            primaryFont: settings.primaryFont,
            secondaryFont: settings.secondaryFont,
            homePageId: settings.homePageId,
            trailingSlashBehavior:
                settings.trailingSlashBehavior == .enforce
                ? .enforce
                : .disable,
            css: settings.css,
            js: settings.js
        )
    }
}
