import AppOpenAPI
import Foundation

struct AppPublicContentDefaultInteractor: AppPublicContentInteractor {
    let repository: any AppPublicContentRepository

    func resolve(
        path: String
    ) async throws -> AppPublicResolvedContent? {
        let settings = AppPublicBlogRouteSettings(
            schema: try await repository.getRouteSettings()
        )
        guard let routePaths = AppPublicRoutePaths(settings: settings) else {
            return nil
        }

        let segments = normalizedSegments(from: path)
        let route: AppPublicResolvedRoute?
        switch segments.count {
        case 1:
            route = try await resolveTopLevel(
                slugOrListPath: segments[0],
                routePaths: routePaths
            )
        case 2:
            route = try await resolvePrefixed(
                prefix: segments[0],
                slug: segments[1],
                routePaths: routePaths
            )
        default:
            return nil
        }
        guard let route else {
            return nil
        }

        async let siteSettings = repository.getSiteSettings()
        async let menus = repository.listMenus()

        return try await .init(
            route: route,
            siteSettings: siteSettings,
            menus: menus
        )
    }
}

extension AppPublicContentDefaultInteractor {
    fileprivate func resolveTopLevel(
        slugOrListPath: String,
        routePaths: AppPublicRoutePaths
    ) async throws -> AppPublicResolvedRoute? {
        if slugOrListPath == routePaths.settings.postListPath {
            return .postList(
                items: try await repository.listBlogPosts(),
                routePaths: routePaths
            )
        }
        if slugOrListPath == routePaths.settings.authorListPath {
            return .authorList(
                items: try await repository.listBlogAuthors(),
                routePaths: routePaths
            )
        }
        if slugOrListPath == routePaths.settings.tagListPath {
            return .tagList(
                items: try await repository.listBlogTags(),
                routePaths: routePaths
            )
        }

        if let page = try await resolvedPage(slug: slugOrListPath) {
            return .pageDetail(detail: page, routePaths: routePaths)
        }

        var blogMatches: [AppPublicResolvedRoute] = []

        if routePaths.settings.postPathPrefix.isEmpty,
            let post = try await resolvedPost(slug: slugOrListPath)
        {
            blogMatches.append(
                .postDetail(detail: post, routePaths: routePaths)
            )
        }
        if routePaths.settings.authorPathPrefix.isEmpty,
            let author = try await resolvedAuthor(slug: slugOrListPath)
        {
            blogMatches.append(
                .authorDetail(detail: author, routePaths: routePaths)
            )
        }
        if routePaths.settings.tagPathPrefix.isEmpty,
            let tag = try await resolvedTag(slug: slugOrListPath)
        {
            blogMatches.append(.tagDetail(detail: tag, routePaths: routePaths))
        }

        guard blogMatches.count <= 1 else {
            return nil
        }
        return blogMatches.first
    }

    fileprivate func resolvePrefixed(
        prefix: String,
        slug: String,
        routePaths: AppPublicRoutePaths
    ) async throws -> AppPublicResolvedRoute? {
        let matches = routePaths.detailPrefixKinds.filter { candidate in
            candidate.prefix == prefix
        }
        guard matches.count == 1, let match = matches.first else {
            return nil
        }

        switch match.kind {
        case .post:
            guard
                let detail = try await resolvedPost(slug: "\(prefix)/\(slug)")
            else {
                return nil
            }
            return .postDetail(detail: detail, routePaths: routePaths)
        case .author:
            guard
                let detail = try await resolvedAuthor(
                    slug: "\(prefix)/\(slug)"
                )
            else {
                return nil
            }
            return .authorDetail(detail: detail, routePaths: routePaths)
        case .tag:
            guard
                let detail = try await resolvedTag(slug: "\(prefix)/\(slug)")
            else {
                return nil
            }
            return .tagDetail(detail: detail, routePaths: routePaths)
        }
    }

    fileprivate func normalizedSegments(
        from path: String
    ) -> [String] {
        path
            .split(separator: "/")
            .map(String.init)
            .filter { !$0.isEmpty }
    }

    fileprivate func resolvedPost(
        slug: String
    ) async throws -> Components.Schemas.BlogPostDetailSchema? {
        guard
            let item = try await repository.listBlogPosts()
                .first(where: {
                    $0.metadata.slug == slug
                })
        else {
            return nil
        }
        return try await repository.getBlogPost(id: item.id)
    }

    fileprivate func resolvedAuthor(
        slug: String
    ) async throws -> Components.Schemas.BlogAuthorDetailSchema? {
        guard
            let item = try await repository.listBlogAuthors()
                .first(where: {
                    $0.metadata.slug == slug
                })
        else {
            return nil
        }
        return try await repository.getBlogAuthor(id: item.id)
    }

    fileprivate func resolvedTag(
        slug: String
    ) async throws -> Components.Schemas.BlogTagDetailSchema? {
        guard
            let item = try await repository.listBlogTags()
                .first(where: {
                    $0.metadata.slug == slug
                })
        else {
            return nil
        }
        return try await repository.getBlogTag(id: item.id)
    }

    fileprivate func resolvedPage(
        slug: String
    ) async throws -> Components.Schemas.WebPageDetailSchema? {
        guard
            let route = try await repository.resolveWebRoute(slug: slug),
            route.referenceType == "web.page"
        else {
            return nil
        }
        return try await repository.getWebPage(id: route.referenceId)
    }
}
