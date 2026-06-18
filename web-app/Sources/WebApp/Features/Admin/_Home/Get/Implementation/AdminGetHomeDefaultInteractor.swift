import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetHomeDefaultInteractor: AdminGetHomeInteractor {
    let repository: any AdminGetHomeRepository

    func getHome(
        permissions: Set<String>
    ) async throws -> AdminGetHomeModel {
        let blogPostsScope = AdminBlog.Scope.posts
        let blogAuthorsScope = AdminBlog.Scope.authors
        let blogTagsScope = AdminBlog.Scope.tags
        let webPagesScope = AdminWeb.Scope.pages
        let webMenusScope = AdminWeb.Scope.menus
        let redirectRulesScope = AdminRedirect.Scope.rules
        let analyticsScope = AdminAnalytics.Scope.insights

        async let blogPostsTotal: Int? =
            permissions.contains(blogPostsScope.permission(for: .list))
            ? loadCount { try await repository.blogPostsTotal() }
            : nil
        async let blogAuthorsTotal: Int? =
            permissions.contains(blogAuthorsScope.permission(for: .list))
            ? loadCount { try await repository.blogAuthorsTotal() }
            : nil
        async let blogTagsTotal: Int? =
            permissions.contains(blogTagsScope.permission(for: .list))
            ? loadCount { try await repository.blogTagsTotal() }
            : nil
        async let webPagesTotal: Int? =
            permissions.contains(webPagesScope.permission(for: .list))
            ? loadCount { try await repository.webPagesTotal() }
            : nil
        async let webMenusTotal: Int? =
            permissions.contains(webMenusScope.permission(for: .list))
            ? loadCount { try await repository.webMenusTotal() }
            : nil
        async let redirectRulesTotal: Int? =
            permissions.contains(redirectRulesScope.permission(for: .list))
            ? loadCount { try await repository.redirectRulesTotal() }
            : nil
        async let webOverview: Components.Schemas.AnalyticsLogOverviewSchema? =
            permissions.contains(analyticsScope.permission(for: .list))
            ? loadWebOverview()
            : nil

        var contentStats: [AdminGetHomeModel.ContentStat] = []
        if let total = await blogPostsTotal {
            contentStats.append(.init(label: "Blog posts", value: "\(total)"))
        }
        if let total = await blogAuthorsTotal {
            contentStats.append(.init(label: "Blog authors", value: "\(total)"))
        }
        if let total = await blogTagsTotal {
            contentStats.append(.init(label: "Blog tags", value: "\(total)"))
        }
        if let total = await webPagesTotal {
            contentStats.append(.init(label: "Web pages", value: "\(total)"))
        }
        if let total = await webMenusTotal {
            contentStats.append(.init(label: "Web menus", value: "\(total)"))
        }
        if let total = await redirectRulesTotal {
            contentStats.append(
                .init(label: "Redirect rules", value: "\(total)")
            )
        }

        let overview = await webOverview
        return .init(
            title: "Admin - Home",
            description:
                "Content overview and quick actions for the admin dashboard.",
            summary:
                "Content inventory, top pages, and quick actions across blog and web modules.",
            contentStats: contentStats,
            dailyTraffic: overview.map(dailyTraffic),
            topPages: overview.map(filteredTopPages),
            webInsightCards: overview.map(webInsightCards) ?? [],
            quickLinkGroups: quickLinkGroups(permissions: permissions)
        )
    }

    private func loadCount(
        _ operation: @escaping @Sendable () async throws -> Int
    ) async -> Int? {
        do {
            return try await operation()
        }
        catch {
            return nil
        }
    }

    private func loadWebOverview() async -> Components.Schemas
        .AnalyticsLogOverviewSchema?
    {
        do {
            let to = Date().timeIntervalSince1970
            let from = to - AdminAnalyticsInsightsPage.Range.last7Days.duration
            return try await repository.webOverview(from: from, to: to)
        }
        catch {
            return nil
        }
    }

    private func dailyTraffic(
        _ overview: Components.Schemas.AnalyticsLogOverviewSchema
    ) -> [AdminGetHomeModel.TrafficPoint] {
        overview.daily.map {
            .init(bucket: $0.bucket, requests: $0.requests)
        }
    }

    private func filteredTopPages(
        _ overview: Components.Schemas.AnalyticsLogOverviewSchema
    ) -> [AdminGetHomeModel.BreakdownItem] {
        Array(overview.paths.map(mapBreakdownItem).prefix(8))
    }

    private func webInsightCards(
        _ overview: Components.Schemas.AnalyticsLogOverviewSchema
    ) -> [AdminGetHomeModel.InsightCard] {
        [
            .init(title: "Top pages", items: filteredTopPages(overview)),
            .init(
                title: "Operating systems",
                items: Array(
                    overview.operatingSystems.map(mapBreakdownItem).prefix(8)
                )
            ),
            .init(
                title: "Browsers",
                items: Array(overview.browsers.map(mapBreakdownItem).prefix(8))
            ),
            .init(
                title: "Device types",
                items: Array(
                    overview.deviceTypes.map(mapBreakdownItem).prefix(8)
                )
            ),
            .init(
                title: "Languages",
                items: Array(overview.languages.map(mapBreakdownItem).prefix(8))
            ),
            .init(
                title: "Regions",
                items: Array(overview.regions.map(mapBreakdownItem).prefix(8))
            ),
        ]
    }

    private func mapBreakdownItem(
        _ item: Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema
    ) -> AdminGetHomeModel.BreakdownItem {
        .init(label: item.label, count: item.count, share: item.share)
    }

    private func quickLinkGroups(
        permissions: Set<String>
    ) -> [AdminGetHomeModel.QuickLinkGroup] {
        [
            quickLinkGroup(
                label: "Posts",
                addLabel: "Add new",
                addHref: "/admin/blog/posts/add/",
                manageLabel: "Edit posts",
                manageHref: "/admin/blog/posts/",
                scope: AdminBlog.Scope.posts,
                permissions: permissions
            ),
            quickLinkGroup(
                label: "Authors",
                addLabel: "Add new",
                addHref: "/admin/blog/authors/add/",
                manageLabel: "Edit authors",
                manageHref: "/admin/blog/authors/",
                scope: AdminBlog.Scope.authors,
                permissions: permissions
            ),
            quickLinkGroup(
                label: "Tags",
                addLabel: "Add new",
                addHref: "/admin/blog/tags/add/",
                manageLabel: "Edit tags",
                manageHref: "/admin/blog/tags/",
                scope: AdminBlog.Scope.tags,
                permissions: permissions
            ),
            quickLinkGroup(
                label: "Pages",
                addLabel: "Add new",
                addHref: "/admin/web/pages/add/",
                manageLabel: "Edit pages",
                manageHref: "/admin/web/pages/",
                scope: AdminWeb.Scope.pages,
                permissions: permissions
            ),
            quickLinkGroup(
                label: "Menus",
                addLabel: "Add new",
                addHref: "/admin/web/menus/add/",
                manageLabel: "Edit menus",
                manageHref: "/admin/web/menus/",
                scope: AdminWeb.Scope.menus,
                permissions: permissions
            ),
            quickLinkGroup(
                label: "Redirects",
                addLabel: "Add new",
                addHref: "/admin/redirect/rules/add/",
                manageLabel: "Edit redirects",
                manageHref: "/admin/redirect/rules/",
                scope: AdminRedirect.Scope.rules,
                permissions: permissions
            ),
        ]
        .compactMap { $0 }
    }

    private func quickLinkGroup(
        label: String,
        addLabel: String,
        addHref: String,
        manageLabel: String,
        manageHref: String,
        scope: PermissionScope,
        permissions: Set<String>
    ) -> AdminGetHomeModel.QuickLinkGroup? {
        var actions: [AdminGetHomeModel.QuickLinkAction] = []
        if permissions.contains(scope.permission(for: .create)) {
            actions.append(
                .init(
                    label: addLabel,
                    href: addHref,
                    style: .primary
                )
            )
        }
        if permissions.contains(scope.permission(for: .list)) {
            actions.append(
                .init(
                    label: manageLabel,
                    href: manageHref,
                    style: .secondary
                )
            )
        }
        guard !actions.isEmpty else {
            return nil
        }
        return .init(label: label, actions: actions)
    }
}
