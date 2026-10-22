import FeatherWebAdmin
import Hummingbird
import Testing

@testable import BlogWebAdmin

@Suite
struct RouterRoutesTestSuite {
    @Test
    func routesUseConfiguredRootAndEncodeParameters() {
        let routes = Router.Routes(
            root: WebRoute.root.appending(pathComponent: "console")
        )

        #expect(routes.post.posts.path == "/console/blog/posts/")
        #expect(
            routes.post.postEditMetadataRoute().path
                == "/console/blog/posts/{id}/edit/metadata/{metadataID}/"
        )
        #expect(
            routes.author.authorEditMetadataRoute().path
                == "/console/blog/authors/{id}/edit/metadata/{metadataID}/"
        )
        #expect(
            routes.tag.tagEditMetadataRoute().path
                == "/console/blog/tags/{id}/edit/metadata/{metadataID}/"
        )
        #expect(
            routes.authorLink
                .authorLinkEdit(
                    "author id",
                    "link/id"
                )
                == "/console/blog/authors/author%20id/links/link%2Fid/edit/"
        )
        #expect(
            routes.authorLink.authorLinkAdd("author id")
                == "/console/blog/authors/author%20id/links/add/"
        )
        #expect(
            routes.authorLink.author("author id")
                == "/console/blog/authors/author%20id/"
        )
    }
}
