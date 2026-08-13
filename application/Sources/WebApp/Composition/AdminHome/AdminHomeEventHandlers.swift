import FeatherContracts
import SystemFrontend
import AnalyticsFrontend
import RedirectFrontend

enum AdminHomeEventHandlers {

    static func register(
        in events: inout EventRegistry
    ) {
        events.register(
            event: AdminHomeMenuItemProvider.self,
            context: AdminDashboardEventContext.self
        ) { event, _ in
            guard event.menuKey == "home" else { return [] }
            return [
                .init(
                    label: "Posts",
                    addLabel: "Add new",
                    addHref: "/admin/blog/posts/add/",
                    manageLabel: "Edit posts",
                    manageHref: "/admin/blog/posts/",
                    createPermission: "blog:posts:create",
                    listPermission: "blog:posts:list"
                ),
                .init(
                    label: "Authors",
                    addLabel: "Add new",
                    addHref: "/admin/blog/authors/add/",
                    manageLabel: "Edit authors",
                    manageHref: "/admin/blog/authors/",
                    createPermission: "blog:authors:create",
                    listPermission: "blog:authors:list"
                ),
                .init(
                    label: "Tags",
                    addLabel: "Add new",
                    addHref: "/admin/blog/tags/add/",
                    manageLabel: "Edit tags",
                    manageHref: "/admin/blog/tags/",
                    createPermission: "blog:tags:create",
                    listPermission: "blog:tags:list"
                ),
                .init(
                    label: "Pages",
                    addLabel: "Add new",
                    addHref: "/admin/web/pages/add/",
                    manageLabel: "Edit pages",
                    manageHref: "/admin/web/pages/",
                    createPermission: "web:pages:create",
                    listPermission: "web:pages:list"
                ),
                .init(
                    label: "Menus",
                    addLabel: "Add new",
                    addHref: "/admin/web/menus/add/",
                    manageLabel: "Edit menus",
                    manageHref: "/admin/web/menus/",
                    createPermission: "web:menus:create",
                    listPermission: "web:menus:list"
                ),
                .init(
                    label: "Redirects",
                    addLabel: "Add new",
                    addHref: "/admin/redirect/rules/add/",
                    manageLabel: "Edit redirects",
                    manageHref: "/admin/redirect/rules/",
                    createPermission: "redirect:rules:create",
                    listPermission: "redirect:rules:list"
                ),
            ]
        }

        events.register(
            event: AdminHomeOverviewProvider.self,
            context: AdminDashboardEventContext.self
        ) { _, context in
            let repository = AdminGetHomeOpenAPIRepository(
                api: .init(
                    apiBaseURL: context.apiBaseURL,
                    sessionToken: context.sessionToken
                ),
                analyticsAPI: .init(
                    apiBaseURL: context.apiBaseURL,
                    sessionToken: context.sessionToken
                ),
                redirectAPI: .init(
                    apiBaseURL: context.apiBaseURL,
                    sessionToken: context.sessionToken
                )
            )

            var contentStats: [AdminGetHomeModel.ContentStat] = []
            await appendCount(
                label: "Blog posts",
                permission: "blog:posts:list",
                permissions: context.permissions,
                operation: { try await repository.blogPostsTotal() },
                to: &contentStats
            )
            await appendCount(
                label: "Blog authors",
                permission: "blog:authors:list",
                permissions: context.permissions,
                operation: { try await repository.blogAuthorsTotal() },
                to: &contentStats
            )
            await appendCount(
                label: "Blog tags",
                permission: "blog:tags:list",
                permissions: context.permissions,
                operation: { try await repository.blogTagsTotal() },
                to: &contentStats
            )
            await appendCount(
                label: "Web pages",
                permission: "web:pages:list",
                permissions: context.permissions,
                operation: { try await repository.webPagesTotal() },
                to: &contentStats
            )
            await appendCount(
                label: "Web menus",
                permission: "web:menus:list",
                permissions: context.permissions,
                operation: { try await repository.webMenusTotal() },
                to: &contentStats
            )
            await appendCount(
                label: "Redirect rules",
                permission: "redirect:rules:list",
                permissions: context.permissions,
                operation: { try await repository.redirectRulesTotal() },
                to: &contentStats
            )

            guard context.permissions.contains("analytics:insights:list") else {
                return [
                    .init(
                        contentStats: contentStats,
                        dailyTraffic: nil,
                        topPages: nil,
                        insightCards: []
                    )
                ]
            }

            let analytics: AdminGetHomeOverview?
            do {
                analytics = try await repository.webOverview(
                    from: context.from,
                    to: context.to
                )
            }
            catch {
                analytics = nil
            }

            let mapBreakdown:
                (
                    [AdminGetHomeOverview.BreakdownItem]
                ) -> [AdminGetHomeModel.BreakdownItem] = { items in
                    items.map {
                        AdminGetHomeModel.BreakdownItem(
                            label: $0.label,
                            count: $0.count,
                            share: $0.share
                        )
                    }
                }
            let topPages = analytics.map {
                Array(mapBreakdown($0.paths).prefix(8))
            }
            var cards: [AdminGetHomeModel.InsightCard] = []
            if let overview = analytics {
                cards = [
                    .init(title: "Top pages", items: topPages ?? []),
                    .init(
                        title: "Operating systems",
                        items: Array(
                            mapBreakdown(overview.operatingSystems).prefix(8)
                        )
                    ),
                    .init(
                        title: "Browsers",
                        items: Array(mapBreakdown(overview.browsers).prefix(8))
                    ),
                    .init(
                        title: "Device types",
                        items: Array(
                            mapBreakdown(overview.deviceTypes).prefix(8)
                        )
                    ),
                    .init(
                        title: "Languages",
                        items: Array(mapBreakdown(overview.languages).prefix(8))
                    ),
                    .init(
                        title: "Regions",
                        items: Array(mapBreakdown(overview.regions).prefix(8))
                    ),
                ]
            }

            return [
                .init(
                    contentStats: contentStats,
                    dailyTraffic: analytics?.daily
                        .map {
                            .init(bucket: $0.bucket, requests: $0.requests)
                        },
                    topPages: topPages,
                    insightCards: cards
                )
            ]
        }
    }

    private static func appendCount(
        label: String,
        permission: String,
        permissions: Set<String>,
        operation: @escaping @Sendable () async throws -> Int,
        to contentStats: inout [AdminGetHomeModel.ContentStat]
    ) async {
        guard permissions.contains(permission) else { return }
        guard let count = try? await operation() else { return }
        contentStats.append(.init(label: label, value: "\(count)"))
    }
}
