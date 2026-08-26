import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import SystemContracts
import WebAppAPI
import WebContracts

public enum WebPublicContentEventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebPublicContentProvider.self,
            context: WebPublicContentEventContext.self
        ) { event, _ in
            try await resolve(event.request)
        }
    }

    private static func resolve(
        _ request: WebPublicContentEventContext
    ) async throws -> WebPublicContentResult? {
        let api = WebAppAPIClient(
            apiBaseURL: FeatherAdmin.AppEnvironmentStore.current.apiBaseURL,
            sessionToken: request.sessionToken
        )
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
        let origins = FeatherAdmin.AppEnvironmentStore.current.publicOrigins
        let navigation =
            menus
            .first(where: { $0.key == "main" })?
            .items
            .map(menuItemContext) ?? []
        var payload: [String: Any] = [
            "baseUrl": normalizedURL(
                base: origins.staticBaseURL,
                path: "theme"
            ),
            "siteBaseUrl": origins.siteBaseURL,
            "staticBaseUrl": origins.staticBaseURL,
            "themeBaseUrl": normalizedURL(
                base: origins.staticBaseURL,
                path: "theme"
            ),
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
        if request.referenceType == "web.page",
            !request.referenceID.isEmpty
        {
            let response = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                try await client.webPageGet(
                    .init(path: .init(id: request.referenceID))
                )
            }
            switch response {
            case .ok(let value):
                let page = try value.body.json
                payload["page"] = pageContext(
                    page: page,
                    requestPath: request.path,
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
        }
        else if request.templateIdentifier == "not-found" {
            payload["page"] = [
                "title": "Page not found",
                "description":
                    "The page you requested does not exist or is not available.",
                "permalink": normalizedURL(
                    base: origins.siteBaseURL,
                    path: request.path
                ),
                "noindex": true,
                "css": [],
                "js": [],
            ]
        }
        return .init(payload: payload)
    }

    private static func siteContext(
        settings: WebAppAPI.Components.Schemas.WebSiteSettingsSchema,
        navigation: [[String: Any]]
    ) -> [String: Any] {
        var context: [String: Any] = [
            "name": settings.title.emptyToNil ?? "Feather CMS",
            "navigation": navigation,
            "noIndex": settings.noIndex,
        ]

        let values = [
            "language": settings.locale,
            "description": settings.excerpt,
            "logo": settings.logo,
            "logoDark": settings.logoDark,
            "metaImage": settings.metaImage,
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
        requestPath: String,
        siteSettings: WebAppAPI.Components.Schemas.WebSiteSettingsSchema,
        siteBaseURL: String
    ) -> [String: Any] {
        let title =
            page.metadata.title.isEmpty
            ? siteSettings.title : page.metadata.title
        let description =
            page.metadata.excerpt.isEmpty
            ? siteSettings.excerpt : page.metadata.excerpt
        let image: String?
        if let imageURL = page.metadata.imageURL.emptyToNil {
            image =
                WebImageURLResolver.resolve(
                    imageURL,
                    mediaBaseURL: FeatherAdmin.AppEnvironmentStore.current
                        .publicOrigins.mediaBaseURL.absoluteString
                )
                .emptyToNil
        }
        else {
            image = siteSettings.metaImage.emptyToNil
        }
        var context: [String: Any] = [
            "title": title,
            "description": description,
            "permalink": normalizedURL(
                base: siteBaseURL,
                path: requestPath
            ),
            "noindex": siteSettings.noIndex
                || page.metadata.noIndex
                || page.metadata.status != "published",
            "contents": ["html": page.content],
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
    ) -> [String: Any] {
        [
            "label": item.label,
            "url": item.url,
            "isBlank": item.isBlank,
        ]
    }

    private static func normalizedURL(
        base: String,
        path: String
    ) -> String {
        var url = base.hasSuffix("/") ? base : base + "/"
        let normalizedPath = path.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        if !normalizedPath.isEmpty {
            url += normalizedPath + "/"
        }
        return url
    }
}
