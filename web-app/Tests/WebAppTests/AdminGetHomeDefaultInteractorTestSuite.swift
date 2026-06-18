import AdminOpenAPI
import Foundation
import Testing

@testable import WebApp

@Suite
struct AdminGetHomeDefaultInteractorTestSuite {

    @Test
    func mapsVisibleTotalsIntoOrderedStats() async throws {
        let repository = MockAdminGetHomeRepository()
        repository.blogPostsTotalValue = 12
        repository.blogAuthorsTotalValue = 3
        repository.blogTagsTotalValue = 7
        repository.webPagesTotalValue = 18
        repository.webMenusTotalValue = 4
        repository.redirectRulesTotalValue = 9
        repository.webOverviewValue = sampleOverview(
            paths: [.init(label: "/home", count: 10, share: 0.5)]
        )

        let interactor = AdminGetHomeDefaultInteractor(repository: repository)
        let permissions: Set<String> = [
            "blog:posts:list",
            "blog:authors:list",
            "blog:tags:list",
            "web:pages:list",
            "web:menus:list",
            "redirect:rules:list",
            "analytics:insights:list",
        ]

        let model = try await interactor.getHome(permissions: permissions)

        #expect(
            model.contentStats.map(\.label) == [
                "Blog posts",
                "Blog authors",
                "Blog tags",
                "Web pages",
                "Web menus",
                "Redirect rules",
            ]
        )
        #expect(
            model.contentStats.map(\.value) == ["12", "3", "7", "18", "4", "9"]
        )
        #expect(model.dailyTraffic?.first?.requests == 9)
        #expect(model.topPages?.first?.label == "/home")
        #expect(
            model.webInsightCards.map(\.title) == [
                "Top pages",
                "Operating systems",
                "Browsers",
                "Device types",
                "Languages",
                "Regions",
            ]
        )
    }

    @Test
    func usesServerFilteredTopPages() async throws {
        let repository = MockAdminGetHomeRepository()
        repository.webOverviewValue = sampleOverview(
            paths: [
                .init(label: "/blog/hello-world/", count: 8, share: 0.16),
                .init(label: "/", count: 5, share: 0.1),
            ]
        )

        let interactor = AdminGetHomeDefaultInteractor(repository: repository)
        let permissions: Set<String> = [
            "analytics:insights:list"
        ]

        let model = try await interactor.getHome(permissions: permissions)

        #expect(model.topPages?.map(\.label) == ["/blog/hello-world/", "/"])
        #expect(
            model.webInsightCards.first?.items.map(\.label) == [
                "/blog/hello-world/", "/",
            ]
        )
    }

    @Test
    func hidesUnauthorizedStatsAndQuickLinks() async throws {
        let repository = MockAdminGetHomeRepository()
        repository.blogPostsTotalValue = 12
        repository.webPagesTotalValue = 18

        let interactor = AdminGetHomeDefaultInteractor(repository: repository)
        let permissions: Set<String> = [
            "blog:posts:list",
            "web:pages:create",
        ]

        let model = try await interactor.getHome(permissions: permissions)

        #expect(model.contentStats.map(\.label) == ["Blog posts"])
        #expect(model.quickLinkGroups.map(\.label) == ["Posts", "Pages"])
        #expect(
            model.quickLinkGroups.first?.actions.map(\.label) == ["Edit posts"]
        )
        #expect(model.quickLinkGroups.last?.actions.map(\.label) == ["Add new"])
        #expect(model.topPages == nil)
    }

    @Test
    func ordersQuickLinksForDashboardGrid() async throws {
        let repository = MockAdminGetHomeRepository()
        let interactor = AdminGetHomeDefaultInteractor(repository: repository)
        let permissions: Set<String> = [
            "blog:posts:list",
            "blog:authors:list",
            "blog:tags:list",
            "web:pages:list",
            "web:menus:list",
            "redirect:rules:list",
        ]

        let model = try await interactor.getHome(permissions: permissions)

        #expect(
            model.quickLinkGroups.map(\.label) == [
                "Posts",
                "Authors",
                "Tags",
                "Pages",
                "Menus",
                "Redirects",
            ]
        )
    }

    @Test
    func omitsFailedStatsAndTopPagesWithoutFailingDashboard() async throws {
        let repository = MockAdminGetHomeRepository()
        repository.blogPostsTotalValue = 12
        repository.blogAuthorsError = MockError.failed
        repository.webOverviewError = MockError.failed

        let interactor = AdminGetHomeDefaultInteractor(repository: repository)
        let permissions: Set<String> = [
            "blog:posts:list",
            "blog:authors:list",
            "analytics:insights:list",
        ]

        let model = try await interactor.getHome(permissions: permissions)

        #expect(model.contentStats.map(\.label) == ["Blog posts"])
        #expect(model.topPages == nil)
        #expect(model.dailyTraffic == nil)
        #expect(model.webInsightCards.isEmpty)
    }
}

private final class MockAdminGetHomeRepository: AdminGetHomeRepository,
    @unchecked Sendable
{
    var blogPostsTotalValue = 0
    var blogAuthorsTotalValue = 0
    var blogTagsTotalValue = 0
    var webPagesTotalValue = 0
    var webMenusTotalValue = 0
    var redirectRulesTotalValue = 0
    var webOverviewValue = sampleOverview()

    var blogPostsError: Error?
    var blogAuthorsError: Error?
    var blogTagsError: Error?
    var webPagesError: Error?
    var webMenusError: Error?
    var redirectRulesError: Error?
    var webOverviewError: Error?

    func blogPostsTotal() async throws -> Int {
        if let blogPostsError {
            throw blogPostsError
        }
        return blogPostsTotalValue
    }

    func blogAuthorsTotal() async throws -> Int {
        if let blogAuthorsError {
            throw blogAuthorsError
        }
        return blogAuthorsTotalValue
    }

    func blogTagsTotal() async throws -> Int {
        if let blogTagsError {
            throw blogTagsError
        }
        return blogTagsTotalValue
    }

    func webPagesTotal() async throws -> Int {
        if let webPagesError {
            throw webPagesError
        }
        return webPagesTotalValue
    }

    func webMenusTotal() async throws -> Int {
        if let webMenusError {
            throw webMenusError
        }
        return webMenusTotalValue
    }

    func redirectRulesTotal() async throws -> Int {
        if let redirectRulesError {
            throw redirectRulesError
        }
        return redirectRulesTotalValue
    }

    func webOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema {
        if let webOverviewError {
            throw webOverviewError
        }
        return webOverviewValue
    }
}

private enum MockError: Error {
    case failed
}

private func sampleOverview(
    paths: [Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema] = [
        .init(label: "/home", count: 10, share: 0.5)
    ]
) -> Components.Schemas.AnalyticsLogOverviewSchema {
    .init(
        query: .init(
            source: "web_app",
            from: 1_718_150_400,
            to: 1_718_236_800
        ),
        kpis: .init(
            totalRequests: 12,
            averageRequestsPerDay: 1.7,
            authenticatedRequests: 9,
            notFoundRequests: 1,
            clientErrorRequests: 1,
            serverErrorRequests: 0
        ),
        daily: [
            .init(
                bucket: 1_718_150_400,
                requests: 9,
                notFoundRequests: 1,
                clientErrorRequests: 1,
                serverErrorRequests: 0
            ),
            .init(
                bucket: 1_718_236_800,
                requests: 3,
                notFoundRequests: 0,
                clientErrorRequests: 0,
                serverErrorRequests: 0
            ),
        ],
        statusFamilies: [],
        methods: [],
        paths: paths,
        notFoundPaths: [],
        serverErrorPaths: [],
        referrers: [],
        browsers: [.init(label: "Chrome", count: 12, share: 1)],
        operatingSystems: [.init(label: "macOS", count: 12, share: 1)],
        deviceTypes: [.init(label: "desktop", count: 12, share: 1)],
        languages: [.init(label: "en", count: 12, share: 1)],
        regions: [.init(label: "US", count: 12, share: 1)]
    )
}
