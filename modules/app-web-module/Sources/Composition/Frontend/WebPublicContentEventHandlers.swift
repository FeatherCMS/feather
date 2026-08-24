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
            "site": [
                "name": siteSettings.title.isEmpty
                    ? "Feather CMS" : siteSettings.title,
                "language": siteSettings.locale,
                "description": siteSettings.excerpt,
                "navigation": navigation,
                "logo": siteSettings.logo,
                "logoDark": siteSettings.logoDark,
                "metaImage": siteSettings.metaImage,
                "noIndex": siteSettings.noIndex,
                "primaryColor": siteSettings.primaryColor,
                "secondaryColor": siteSettings.secondaryColor,
                "tertiaryColor": siteSettings.tertiaryColor,
                "primaryFont": siteSettings.primaryFont,
                "secondaryFont": siteSettings.secondaryFont,
                "cssCodeInjection": siteSettings.css,
                "javascriptCodeInjection": siteSettings.js,
            ],
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
        return [
            "title": title,
            "description": description,
            "image": page.metadata.imageURL.isEmpty
                ? siteSettings.metaImage
                : WebImageURLResolver.resolve(
                    page.metadata.imageURL,
                    mediaBaseURL: FeatherAdmin.AppEnvironmentStore.current
                        .publicOrigins.mediaBaseURL.absoluteString
                ),
            "permalink": normalizedURL(
                base: siteBaseURL,
                path: requestPath
            ),
            "noindex": siteSettings.noIndex
                || page.metadata.noIndex
                || page.metadata.status != "published",
            "css": page.metadata.cssCodeInjection as Any,
            "js": page.metadata.javascriptCodeInjection as Any,
            "contents": ["html": page.content],
        ]
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
