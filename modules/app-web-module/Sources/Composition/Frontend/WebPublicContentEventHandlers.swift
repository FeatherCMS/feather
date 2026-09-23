import FeatherAdmin
import FeatherContracts
import Foundation
import HummingbirdCore
import OpenAPIRuntime
import WebAppAPI
import WebContracts

public enum WebPublicContentEventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebPublicContentProvider.self,
            context: WebPublicContentEventContext<RuntimeBuilderContext>.self
        ) { _, context in
            try await resolve(context)
        }
    }

    private static func resolve(
        _ context: WebPublicContentEventContext<RuntimeBuilderContext>
    ) async throws -> WebPublicContentResult? {
        let api = context.runtime.context.webApplicationAPI()
        let siteSettings = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            let response = try await client.webSiteSettings(.init())
            switch response {
            case .ok(let value): return try value.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
        let menus = try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuList(.init())
            switch response {
            case .ok(let value): return try value.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
        let origins = unsafe FeatherAdmin.AppEnvironmentStore.current
            .publicOrigins
        let navigation =
            menus
            .first(where: { $0.key == "main" })?
            .items
            .map(menuItemContext) ?? []
        var payload: [String: any Sendable] = [
            "baseUrl": normalizedURL(
                base: origins.staticBaseURL,
                slug: ""
            ),
            "siteBaseUrl": origins.siteBaseURL,
            "staticBaseUrl": origins.staticBaseURL,
            "site": siteContext(
                settings: siteSettings,
                navigation: navigation
            ),
            "generation": [
                "year": String(
                    Calendar.current.component(.year, from: Date())
                )
            ],
        ]
        switch context.baseMetadata.template {
        case "web.page":
            guard !context.baseMetadata.referenceId.isEmpty else { return nil }
            let referenceID = context.baseMetadata.referenceId
            let response = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                try await client.webPageGet(
                    .init(path: .init(id: referenceID))
                )
            }
            switch response {
            case .ok(let value):
                let page = try value.body.json
                payload["page"] = pageContext(
                    page: page,
                    slug: context.baseMetadata.slug,
                    siteSettings: siteSettings,
                    siteBaseURL: origins.siteBaseURL
                )
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        case "not-found":
            payload["page"] =
                [
                    "title": "Page not found",
                    "description":
                        "The page you requested does not exist or is not available.",
                    "permalink": normalizedURL(
                        base: origins.siteBaseURL,
                        slug: context.baseMetadata.slug
                    ),
                    "noindex": true,
                    "css": [String](),
                    "js": [String](),
                ] as [String: any Sendable]
        default:
            break
        }
        return .init(payload: payload)
    }

    private static func siteContext(
        settings: WebAppAPI.Components.Schemas.WebSiteSettingsSchema,
        navigation: [[String: any Sendable]]
    ) -> [String: any Sendable] {
        var context: [String: any Sendable] = [
            "navigation": navigation,
            "noIndex": settings.noIndex,
        ]

        if let name = settings.title.emptyToNil {
            context["name"] = name
        }

        let resolver = unsafe AppEnvironmentStore.current.mediaResolver
        let values = [
            "language": settings.locale,
            "description": settings.excerpt,
            "logo": resolver.resolve(imagePath: settings.logo) ?? "",
            "logoDark": resolver.resolve(imagePath: settings.logoDark) ?? "",
            "metaImage": resolver.resolve(imagePath: settings.metaImage) ?? "",
            "primaryColor": settings.primaryColor,
            "secondaryColor": settings.secondaryColor,
            "tertiaryColor": settings.tertiaryColor,
            "primaryFont": settings.primaryFont,
            "secondaryFont": settings.secondaryFont,
            "cssCodeInjection": settings.css,
            "javascriptCodeInjection": settings.js,
        ]

        for (key, value) in values {
            if let value = value.emptyToNil {
                context[key] = value
            }
        }

        return context
    }

    private static func pageContext(
        page: WebAppAPI.Components.Schemas.WebPageDetailSchema,
        slug: String,
        siteSettings: WebAppAPI.Components.Schemas.WebSiteSettingsSchema,
        siteBaseURL: String
    ) -> [String: any Sendable] {
        let title =
            page.metadata.title.isEmpty
            ? siteSettings.title : page.metadata.title
        let description =
            page.metadata.excerpt.isEmpty
            ? siteSettings.excerpt : page.metadata.excerpt
        let resolver = unsafe AppEnvironmentStore.current.mediaResolver
        let image: String?
        if let imageURL = page.metadata.imageURL.emptyToNil {
            image = resolver.resolve(imagePath: imageURL)
        }
        else {
            image = resolver.resolve(imagePath: siteSettings.metaImage)
        }
        var context: [String: any Sendable] = [
            "title": title,
            "description": description,
            "permalink": normalizedURL(base: siteBaseURL, slug: slug),
            "noindex": siteSettings.noIndex
                || page.metadata.noIndex
                || page.metadata.status != "published",
            "contents": ["html": page.content] as [String: any Sendable],
        ]

        if let image {
            context["image"] = image
        }
        if let css = page.metadata.cssCodeInjection {
            context["css"] = css
        }
        if let js = page.metadata.javascriptCodeInjection {
            context["js"] = js
        }

        return context
    }

    private static func menuItemContext(
        _ item: WebAppAPI.Components.Schemas.WebMenuItemSchema
    ) -> [String: any Sendable] {
        [
            "label": item.label,
            "url": item.url,
            "isBlank": item.isBlank,
        ]
    }

    private static func normalizedURL(
        base: String,
        slug: String
    ) -> String {
        var url = base.hasSuffix("/") ? base : base + "/"
        let normalizedPath = slug.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        if !normalizedPath.isEmpty {
            url += normalizedPath + "/"
        }
        return url
    }
}
