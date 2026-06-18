import AppOpenAPI
import Testing

@testable import WebApp

@Suite
struct AppPublicContentRouteTestSuite {

    @Test
    func routePathsRejectDuplicateListPaths() {
        let settings = AppPublicBlogRouteSettings(
            schema: .init(
                postListPath: "blog",
                authorListPath: "blog",
                tagListPath: "tags",
                postPathPrefix: "posts",
                authorPathPrefix: "authors",
                tagPathPrefix: "tags",
                siteNoIndex: false
            )
        )

        #expect(AppPublicRoutePaths(settings: settings) == nil)
    }

    @Test
    func routePathsRejectDuplicateNonEmptyDetailPrefixes() {
        let settings = AppPublicBlogRouteSettings(
            schema: .init(
                postListPath: "blog",
                authorListPath: "authors",
                tagListPath: "tags",
                postPathPrefix: "entry",
                authorPathPrefix: "entry",
                tagPathPrefix: "tags",
                siteNoIndex: false
            )
        )

        #expect(AppPublicRoutePaths(settings: settings) == nil)
    }

    @Test
    func topLevelListPathResolvesBeforePageLookup() async throws {
        let repo = MockPublicContentRepository()
        repo.routeSettings = .init(
            postListPath: "blog",
            authorListPath: "authors",
            tagListPath: "tags",
            postPathPrefix: "posts",
            authorPathPrefix: "authors",
            tagPathPrefix: "tags",
            siteNoIndex: false
        )
        repo.postList = [postSummary(slug: "one")]
        repo.page = pageDetail(slug: "blog")

        let interactor = AppPublicContentDefaultInteractor(repository: repo)
        let content = try await interactor.resolve(path: "/blog/")

        guard case .postList(let items, _) = content?.route else {
            Issue.record("Expected post list route")
            return
        }
        #expect(items.count == 1)
    }

    @Test
    func pageWinsOverEmptyPrefixBlogContent() async throws {
        let repo = MockPublicContentRepository()
        repo.routeSettings = .init(
            postListPath: "blog",
            authorListPath: "authors",
            tagListPath: "tags",
            postPathPrefix: "",
            authorPathPrefix: "authors",
            tagPathPrefix: "tags",
            siteNoIndex: false
        )
        repo.page = pageDetail(slug: "hello")
        repo.route = .init(
            referenceType: "web.page",
            referenceId: "hello",
            slug: "hello"
        )
        repo.post = postDetail(slug: "hello")

        let interactor = AppPublicContentDefaultInteractor(repository: repo)
        let content = try await interactor.resolve(path: "/hello/")

        guard case .pageDetail(let detail, _) = content?.route else {
            Issue.record("Expected page detail route")
            return
        }
        #expect(detail.metadata.slug == "hello")
    }

    @Test
    func duplicateEmptyPrefixBlogMatchesAreRejected() async throws {
        let repo = MockPublicContentRepository()
        repo.routeSettings = .init(
            postListPath: "blog",
            authorListPath: "authors",
            tagListPath: "tags",
            postPathPrefix: "",
            authorPathPrefix: "",
            tagPathPrefix: "tags",
            siteNoIndex: false
        )
        repo.postList = [postSummary(slug: "hello")]
        repo.authorList = [authorSummary(slug: "hello")]
        repo.post = postDetail(slug: "hello")
        repo.author = authorDetail(slug: "hello")

        let interactor = AppPublicContentDefaultInteractor(repository: repo)
        let content = try await interactor.resolve(path: "/hello/")

        #expect(content == nil)
    }
}

private final class MockPublicContentRepository: AppPublicContentRepository,
    @unchecked Sendable
{
    var routeSettings = Components.Schemas.BlogRouteSettingsSchema(
        postListPath: "blog",
        authorListPath: "authors",
        tagListPath: "tags",
        postPathPrefix: "posts",
        authorPathPrefix: "authors",
        tagPathPrefix: "tags",
        siteNoIndex: false
    )
    var postList: Components.Schemas.BlogPostListSchema = []
    var authorList: Components.Schemas.BlogAuthorListSchema = []
    var tagList: Components.Schemas.BlogTagListSchema = []
    var post: Components.Schemas.BlogPostDetailSchema?
    var author: Components.Schemas.BlogAuthorDetailSchema?
    var tag: Components.Schemas.BlogTagDetailSchema?
    var page: Components.Schemas.WebPageDetailSchema?
    var route: Components.Schemas.WebMetadataSchema?
    var siteSettings = Components.Schemas.WebSiteSettingsSchema(
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
        css: "",
        js: ""
    )
    var menus: Components.Schemas.WebMenuListSchema = []

    func getRouteSettings() async throws
        -> Components.Schemas.BlogRouteSettingsSchema
    {
        routeSettings
    }

    func listBlogPosts() async throws -> Components.Schemas.BlogPostListSchema {
        postList
    }

    func getSiteSettings() async throws
        -> Components.Schemas.WebSiteSettingsSchema
    {
        siteSettings
    }

    func listMenus() async throws -> Components.Schemas.WebMenuListSchema {
        menus
    }

    func resolveWebRoute(
        slug: String
    ) async throws -> Components.Schemas.WebMetadataSchema? {
        route?.slug == slug ? route : nil
    }

    func getBlogPost(
        id: String
    ) async throws -> Components.Schemas.BlogPostDetailSchema? {
        post?.id == id ? post : nil
    }

    func listBlogAuthors() async throws
        -> Components.Schemas.BlogAuthorListSchema
    {
        authorList
    }

    func getBlogAuthor(
        id: String
    ) async throws -> Components.Schemas.BlogAuthorDetailSchema? {
        author?.id == id ? author : nil
    }

    func listBlogTags() async throws -> Components.Schemas.BlogTagListSchema {
        tagList
    }

    func getBlogTag(
        id: String
    ) async throws -> Components.Schemas.BlogTagDetailSchema? {
        tag?.id == id ? tag : nil
    }

    func getWebPage(
        id: String
    ) async throws -> Components.Schemas.WebPageDetailSchema? {
        page?.id == id ? page : nil
    }
}

private func metadata(
    slug: String
) -> Components.Schemas.WebMetadataContentSchema {
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
) -> Components.Schemas.BlogPostSummarySchema {
    .init(
        id: slug,
        excerpt: "Excerpt \(slug)",
        imageURL: "",
        metadata: metadata(slug: slug)
    )
}

private func postDetail(
    slug: String
) -> Components.Schemas.BlogPostDetailSchema {
    .init(
        id: slug,
        excerpt: "Excerpt \(slug)",
        content: "Body",
        imageURL: "",
        metadata: metadata(slug: slug),
        authors: [],
        tags: []
    )
}

private func authorDetail(
    slug: String
) -> Components.Schemas.BlogAuthorDetailSchema {
    .init(
        id: slug,
        name: "Author \(slug)",
        excerpt: "Excerpt \(slug)",
        content: "Body",
        imageURL: "",
        metadata: metadata(slug: slug),
        links: [],
        posts: []
    )
}

private func authorSummary(
    slug: String
) -> Components.Schemas.BlogAuthorSummarySchema {
    .init(
        id: slug,
        name: "Author \(slug)",
        excerpt: "Excerpt \(slug)",
        content: "Body",
        imageURL: "",
        metadata: metadata(slug: slug)
    )
}

private func pageDetail(
    slug: String
) -> Components.Schemas.WebPageDetailSchema {
    .init(
        id: slug,
        excerpt: "Excerpt \(slug)",
        content: "Body",
        imageURL: "",
        metadata: metadata(slug: slug)
    )
}
