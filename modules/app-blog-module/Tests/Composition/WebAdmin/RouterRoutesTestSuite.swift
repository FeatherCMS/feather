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
            routes.post.postEditMetadataRoute().description
                == "/console/blog/posts/{id}/edit/metadata/{metadataID}"
        )
        #expect(
            routes.author.authorEditMetadataRoute().description
                == "/console/blog/authors/{id}/edit/metadata/{metadataID}"
        )
        #expect(
            routes.tag.tagEditMetadataRoute().description
                == "/console/blog/tags/{id}/edit/metadata/{metadataID}"
        )
        #expect(
            routes.authorLink.authorLinkEdit(
                RouterPath("author id"),
                RouterPath("link/id")
            )
            .description
                == "/console/blog/authors/author%20id/links/link%2Fid/edit"
        )
    }
}
