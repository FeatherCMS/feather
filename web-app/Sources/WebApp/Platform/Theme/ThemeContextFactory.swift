import AppOpenAPI
import Foundation
import Hummingbird

struct ThemeContextFactory {
    let publicOrigins: AppPublicOriginConfiguration
    let contentRenderer: any ContentRenderer

    func makeHomeContext(
        request: Request,
        posts: [AppPublicPostSummaryModel],
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema]
    ) -> ThemePageContext {
        .init(
            template: .blogHome,
            value: makeContext(
                request: request,
                title: siteSettings.title,
                description: siteSettings.description,
                imageURL: siteSettings.metaImageURL,
                canonicalURL: nil,
                noIndex: siteSettings.noIndex,
                contentsHTML: homeHeaderHTML(siteSettings: siteSettings),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [:],
                extraRoot: [
                    "context": [
                        "posts": posts.map(postSummaryObject)
                    ]
                ]
            )
        )
    }

    func makePageContext(
        request: Request,
        model: AppGetWebPageModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .pageDefault,
            value: makeContext(
                request: request,
                title: model.metadata.seoTitle(fallback: model.title),
                description: model.metadata.seoDescription(fallback: model.excerpt),
                imageURL: model.metadata.seoImageURL(
                    fallback: model.imageURL ?? siteSettings.metaImageURL
                ),
                canonicalURL: nonEmpty(model.metadata.canonicalURL),
                noIndex: siteNoIndex || siteSettings.noIndex || model.metadata.noIndex,
                contentsHTML: renderedContentsHTML(
                    markdown: model.content,
                    requestPath: request.uri.path
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [:]
            )
        )
    }

    func makePostListContext(
        request: Request,
        model: AppGetBlogPostListModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .blogPosts,
            value: makeContext(
                request: request,
                title: model.title,
                description: "Published blog posts",
                imageURL: siteSettings.metaImageURL,
                canonicalURL: nil,
                noIndex: siteNoIndex || siteSettings.noIndex,
                contentsHTML: headerHTML(
                    eyebrow: nil,
                    title: model.title,
                    description: "Published blog posts"
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [:],
                extraRoot: [
                    "iterator": [
                        "items": model.items.map(postSummaryObject)
                    ]
                ]
            )
        )
    }

    func makePostDetailContext(
        request: Request,
        model: AppGetBlogPostModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .blogPostDefault,
            value: makeContext(
                request: request,
                title: model.metadata.seoTitle(fallback: model.title),
                description: model.metadata.seoDescription(fallback: model.excerpt),
                imageURL: model.metadata.seoImageURL(
                    fallback: model.imageURL ?? siteSettings.metaImageURL
                ),
                canonicalURL: nonEmpty(model.metadata.canonicalURL),
                noIndex: siteNoIndex || siteSettings.noIndex || model.metadata.noIndex,
                contentsHTML: renderedContentsHTML(
                    markdown: model.content,
                    requestPath: request.uri.path
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [
                    "publicationLabel": model.publishedAt ?? "",
                    "authors": model.authors.map(authorReferenceObject),
                    "tags": model.tags.map(tagReferenceObject)
                ]
            )
        )
    }

    func makeAuthorListContext(
        request: Request,
        model: AppGetBlogAuthorListModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .blogAuthors,
            value: makeContext(
                request: request,
                title: model.title,
                description: "Published authors",
                imageURL: siteSettings.metaImageURL,
                canonicalURL: nil,
                noIndex: siteNoIndex || siteSettings.noIndex,
                contentsHTML: headerHTML(
                    eyebrow: nil,
                    title: model.title,
                    description: "Published authors"
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [:],
                extraRoot: [
                    "context": [
                        "authors": model.items.map(authorSummaryObject)
                    ]
                ]
            )
        )
    }

    func makeAuthorDetailContext(
        request: Request,
        model: AppGetBlogAuthorModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .blogAuthorDefault,
            value: makeContext(
                request: request,
                title: model.metadata.seoTitle(fallback: model.title),
                description: model.metadata.seoDescription(fallback: model.subtitle),
                imageURL: model.metadata.seoImageURL(
                    fallback: model.imageURL ?? siteSettings.metaImageURL
                ),
                canonicalURL: nonEmpty(model.metadata.canonicalURL),
                noIndex: siteNoIndex || siteSettings.noIndex || model.metadata.noIndex,
                contentsHTML: renderedContentsHTML(
                    markdown: model.content,
                    requestPath: request.uri.path
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [
                    "posts": model.posts.map(postSummaryObject),
                    "postCountLabel": "\(model.posts.count) posts",
                    "links": model.links.map(authorLinkObject)
                ]
            )
        )
    }

    func makeTagListContext(
        request: Request,
        model: AppGetBlogTagListModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .blogTags,
            value: makeContext(
                request: request,
                title: model.title,
                description: "Published tags",
                imageURL: siteSettings.metaImageURL,
                canonicalURL: nil,
                noIndex: siteNoIndex || siteSettings.noIndex,
                contentsHTML: headerHTML(
                    eyebrow: nil,
                    title: model.title,
                    description: "Published tags"
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [:],
                extraRoot: [
                    "context": [
                        "tags": model.items.map(tagSummaryObject)
                    ]
                ]
            )
        )
    }

    func makeTagDetailContext(
        request: Request,
        model: AppGetBlogTagModel,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        siteNoIndex: Bool
    ) -> ThemePageContext {
        .init(
            template: .blogTagDefault,
            value: makeContext(
                request: request,
                title: model.metadata.seoTitle(fallback: model.title),
                description: model.metadata.seoDescription(fallback: model.excerpt),
                imageURL: model.metadata.seoImageURL(
                    fallback: model.imageURL ?? siteSettings.metaImageURL
                ),
                canonicalURL: nonEmpty(model.metadata.canonicalURL),
                noIndex: siteNoIndex || siteSettings.noIndex || model.metadata.noIndex,
                contentsHTML: renderedContentsHTML(
                    markdown: model.content,
                    requestPath: request.uri.path
                ),
                siteSettings: siteSettings,
                navigation: navigation,
                extraPage: [
                    "posts": model.posts.map(postSummaryObject),
                    "postCountLabel": "\(model.posts.count) posts"
                ]
            )
        )
    }
}

extension ThemeContextFactory {
    private func makeContext(
        request: Request,
        title: String,
        description: String,
        imageURL: String,
        canonicalURL: String?,
        noIndex: Bool,
        contentsHTML: String,
        siteSettings: SiteSettingsModel,
        navigation: [Components.Schemas.WebMenuItemSchema],
        extraPage: [String: Any],
        extraRoot: [String: Any] = [:]
    ) -> [String: Any] {
        var page: [String: Any] = [
            "title": title,
            "description": description,
            "permalink": normalizedCanonicalURL(
                requestPath: request.uri.path,
                override: canonicalURL
            ),
            "image": normalizedPublicImageURL(imageURL, fallback: siteSettings.metaImageURL),
            "noindex": noIndex,
            "contents": [
                "html": contentsHTML
            ],
            "css": [],
            "js": []
        ]
        for (key, value) in extraPage {
            page[key] = value
        }

        var context: [String: Any] = [
            "site": [
                "name": siteSettings.title,
                "language": siteSettings.language,
                "description": siteSettings.description,
                "navigation": navigation.map(navigationObject),
                "logo": siteSettings.logoURL,
                "logoDark": siteSettings.logoDarkURL,
                "metaImage": siteSettings.metaImageURL,
                "noIndex": siteSettings.noIndex,
                "primaryColor": siteSettings.primaryColor,
                "secondaryColor": siteSettings.secondaryColor,
                "tertiaryColor": siteSettings.tertiaryColor,
                "primaryFont": siteSettings.primaryFont,
                "secondaryFont": siteSettings.secondaryFont,
                "cssCodeInjection": siteSettings.cssCodeInjection,
                "javascriptCodeInjection": siteSettings.javascriptCodeInjection
            ],
            "baseUrl": normalizedURL(
                base: publicOrigins.staticBaseURL,
                path: "/theme"
            ),
            "auth": authObject(request: request),
            "page": page,
            "siteBaseUrl": publicOrigins.siteBaseURL,
            "staticBaseUrl": publicOrigins.staticBaseURL,
            "themeBaseUrl": normalizedURL(
                base: publicOrigins.staticBaseURL,
                path: "/theme"
            ),
            "generation": [
                "year": String(Calendar.current.component(.year, from: Date()))
            ]
        ]
        for (key, value) in extraRoot {
            context[key] = value
        }
        return context
    }

    private func navigationObject(
        _ item: Components.Schemas.WebMenuItemSchema
    ) -> [String: Any] {
        [
            "label": item.label,
            "url": item.url,
            "isBlank": item.isBlank
        ]
    }

    private func renderedContentsHTML(
        markdown: String,
        requestPath: String
    ) -> String {
        contentRenderer.render(
            markdown: markdown,
            requestPath: requestPath
        )
    }

    private func authObject(
        request: Request
    ) -> [String: Any] {
        let isSignedIn = request.cookies["session_token"]?.value.isEmpty == false
        return [
            "isSignedIn": isSignedIn,
            "loginURL": "/login/",
            "logoutURL": "/logout/",
            "adminURL": "/admin/"
        ]
    }

    private func postSummaryObject(
        _ item: AppPublicPostSummaryModel
    ) -> [String: Any] {
        [
            "title": item.title,
            "description": item.excerpt,
            "permalink": item.href,
            "publicationLabel": item.publishedAt ?? "",
            "image": normalizedPublicImageURL(
                item.metadata.seoImageURL(fallback: ""),
                fallback: ""
            ),
            "hasImage": nonEmpty(item.metadata.seoImageURL(fallback: "")) != nil
        ]
    }

    private func authorSummaryObject(
        _ item: AppPublicAuthorSummaryModel
    ) -> [String: Any] {
        [
            "title": item.name,
            "description": item.excerpt,
            "permalink": item.href,
            "image": normalizedPublicImageURL(item.imageURL ?? "", fallback: ""),
            "hasImage": item.imageURL != nil
        ]
    }

    private func tagSummaryObject(
        _ item: AppPublicTagSummaryModel
    ) -> [String: Any] {
        [
            "title": item.title,
            "description": item.excerpt,
            "permalink": item.href
        ]
    }

    private func authorReferenceObject(
        _ item: AppPublicAuthorSummaryModel
    ) -> [String: Any] {
        [
            "title": item.name,
            "permalink": item.href,
            "image": normalizedPublicImageURL(item.imageURL ?? "", fallback: ""),
            "hasImage": item.imageURL != nil
        ]
    }

    private func tagReferenceObject(
        _ item: AppPublicTagSummaryModel
    ) -> [String: Any] {
        [
            "title": item.title,
            "permalink": item.href
        ]
    }

    private func authorLinkObject(
        _ item: AppPublicAuthorLinkModel
    ) -> [String: Any] {
        [
            "label": item.label,
            "url": item.url,
            "isBlank": item.isBlank
        ]
    }

    private func headerHTML(
        eyebrow: String?,
        title: String,
        description: String
    ) -> String {
        var fragments: [String] = ["<section class=\"group\">"]
        if let eyebrow, !eyebrow.isEmpty {
            fragments.append("<p>\(eyebrow)</p>")
        }
        fragments.append("<h1>\(title)</h1>")
        if !description.isEmpty {
            fragments.append("<p>\(description)</p>")
        }
        fragments.append("</section>")
        return fragments.joined()
    }

    private func homeHeaderHTML(
        siteSettings: SiteSettingsModel
    ) -> String {
        headerHTML(
            eyebrow: nil,
            title: siteSettings.title,
            description: siteSettings.description
        )
    }

    private func normalizedURL(
        base: String,
        path: String
    ) -> String {
        var url = base
        if !url.hasSuffix("/") {
            url += "/"
        }
        let normalizedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        if normalizedPath.isEmpty {
            return url
        }
        url += normalizedPath
        if normalizedPath.contains(".") {
            return url
        }
        if !url.hasSuffix("/") {
            url += "/"
        }
        return url
    }

    private func normalizedCanonicalURL(
        requestPath: String,
        override: String?
    ) -> String {
        guard let override = nonEmpty(override) else {
            return normalizedURL(base: publicOrigins.siteBaseURL, path: requestPath)
        }
        return override
    }

    private func normalizedPublicImageURL(
        _ imageURL: String,
        fallback: String
    ) -> String {
        let candidate = nonEmpty(imageURL) ?? fallback
        guard !candidate.isEmpty else {
            return ""
        }
        if candidate.hasPrefix("http://") || candidate.hasPrefix("https://") {
            return candidate
        }
        if candidate.hasPrefix("/media/") || candidate.hasPrefix("media/") {
            return normalizedURL(
                base: publicOrigins.mediaBaseURL.absoluteString,
                path: candidate
            )
        }
        return normalizedURL(base: publicOrigins.staticBaseURL, path: candidate)
    }

    private func nonEmpty(
        _ value: String?
    ) -> String? {
        guard let value else {
            return nil
        }
        return value.isEmpty ? nil : value
    }
}
