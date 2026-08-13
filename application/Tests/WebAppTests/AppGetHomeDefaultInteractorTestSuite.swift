import BlogAppAPI
import WebAppAPI
import Testing

@testable import WebApp

private typealias BlogComponents = BlogAppAPI.Components
private typealias WebComponents = WebAppAPI.Components

private func blogMetadata(
    slug: String
) -> BlogComponents.Schemas.WebMetadataContentSchema {
    .init(
        slug: slug,
        status: "published",
        title: "Title \(slug)",
        excerpt: "Excerpt \(slug)",
        imageURL: "",
        canonicalURL: "",
        noIndex: false,
        cssCodeInjection: "",
        javascriptCodeInjection: "",
        structuredDataCodeInjection: ""
    )
}

@Suite
struct AppGetHomeDefaultInteractorTestSuite {

    @Test
    func configuredHomePageReturnsPageModel() async throws {
        let repository = MockAppGetHomeRepository()
        repository.siteSettings = .init(
            title: "Feather CMS",
            excerpt: "Description",
            locale: "en-US",
            noIndex: false,
            logo: "",
            logoDark: "",
            metaImage: "",
            primaryColor: "",
            secondaryColor: "",
            tertiaryColor: "",
            primaryFont: "",
            secondaryFont: "",
            homePageId: "home-page",
            css: "",
            js: ""
        )
        repository.page = pageDetail(id: "home-page", slug: "welcome")

        let interactor = AppGetHomeDefaultInteractor(repository: repository)
        let model = try await interactor.getHome(account: nil)

        guard case .page(let content) = model else {
            Issue.record(
                "Expected configured homepage to render as page content"
            )
            return
        }
        guard case .pageDetail(let detail, _) = content.route else {
            Issue.record("Expected homepage route to be a page detail")
            return
        }
        #expect(detail.id == "home-page")
        #expect(content.siteSettings.homePageId == "home-page")
    }

    @Test
    func missingConfiguredHomePageFallsBackToDefaultHome() async throws {
        let repository = MockAppGetHomeRepository()
        repository.siteSettings = .init(
            title: "Feather CMS",
            excerpt: "Description",
            locale: "en-US",
            noIndex: false,
            logo: "",
            logoDark: "",
            metaImage: "",
            primaryColor: "",
            secondaryColor: "",
            tertiaryColor: "",
            primaryFont: "",
            secondaryFont: "",
            homePageId: "missing-page",
            css: "",
            js: ""
        )
        repository.postList = [postSummary(slug: "one")]

        let interactor = AppGetHomeDefaultInteractor(repository: repository)
        let model = try await interactor.getHome(account: nil)

        guard case .defaultHome(_, _, let posts, _) = model else {
            Issue.record("Expected fallback homepage model")
            return
        }
        #expect(posts.count == 1)
    }
}

private final class MockAppGetHomeRepository: AppPublicContentRepository,
    @unchecked Sendable
{
    var routeSettings = BlogComponents.Schemas.BlogRouteSettingsSchema(
        postListPath: "blog",
        authorListPath: "authors",
        tagListPath: "tags",
        postPathPrefix: "posts",
        authorPathPrefix: "authors",
        tagPathPrefix: "tags",
        siteNoIndex: false
    )
    var siteSettings = WebComponents.Schemas.WebSiteSettingsSchema(
        title: "Feather CMS",
        excerpt: "Description",
        locale: "en-US",
        noIndex: false,
        logo: "",
        logoDark: "",
        metaImage: "",
        primaryColor: "",
        secondaryColor: "",
        tertiaryColor: "",
        primaryFont: "",
        secondaryFont: "",
        homePageId: nil,
        css: "",
        js: ""
    )
    var menus: WebComponents.Schemas.WebMenuListSchema = []
    var postList: BlogComponents.Schemas.BlogPostListSchema = []
    var page: WebComponents.Schemas.WebPageDetailSchema?

    func getRouteSettings() async throws
        -> BlogComponents.Schemas.BlogRouteSettingsSchema
    {
        routeSettings
    }

    func getSiteSettings() async throws
        -> WebComponents.Schemas.WebSiteSettingsSchema
    {
        siteSettings
    }

    func listMenus() async throws -> WebComponents.Schemas.WebMenuListSchema {
        menus
    }

    func listBlogPosts() async throws
        -> BlogComponents.Schemas.BlogPostListSchema
    {
        postList
    }

    func resolveWebRoute(
        slug: String
    ) async throws -> WebComponents.Schemas.WebMetadataSchema? {
        nil
    }

    func getBlogPost(
        id: String
    ) async throws -> BlogComponents.Schemas.BlogPostDetailSchema? {
        nil
    }

    func listBlogAuthors() async throws
        -> BlogComponents.Schemas.BlogAuthorListSchema
    {
        []
    }

    func getBlogAuthor(
        id: String
    ) async throws -> BlogComponents.Schemas.BlogAuthorDetailSchema? {
        nil
    }

    func listBlogTags() async throws -> BlogComponents.Schemas.BlogTagListSchema
    {
        []
    }

    func getBlogTag(
        id: String
    ) async throws -> BlogComponents.Schemas.BlogTagDetailSchema? {
        nil
    }

    func getWebPage(
        id: String
    ) async throws -> WebComponents.Schemas.WebPageDetailSchema? {
        page?.id == id ? page : nil
    }
}

private func metadata(
    slug: String
) -> WebComponents.Schemas.WebMetadataContentSchema {
    .init(
        slug: slug,
        status: "published",
        title: "Title \(slug)",
        excerpt: "Excerpt \(slug)",
        imageURL: "",
        canonicalURL: "",
        noIndex: false,
        cssCodeInjection: "",
        javascriptCodeInjection: "",
        structuredDataCodeInjection: ""
    )
}

private func postSummary(
    slug: String
) -> BlogComponents.Schemas.BlogPostSummarySchema {
    .init(
        id: slug,
        excerpt: "Excerpt \(slug)",
        imageURL: "",
        metadata: blogMetadata(slug: slug)
    )
}

private func pageDetail(
    id: String,
    slug: String
) -> WebComponents.Schemas.WebPageDetailSchema {
    .init(
        id: id,
        excerpt: "Excerpt \(slug)",
        content: "Body",
        imageURL: "",
        metadata: metadata(slug: slug)
    )
}
