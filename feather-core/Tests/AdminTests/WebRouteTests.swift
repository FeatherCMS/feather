import FeatherWebAdmin
import Hummingbird
import Testing

@Suite
struct WebRouteTests {
    @Test
    func buildsFrameworkIndependentRoutePatterns() {
        let route = WebRoute.root
            .appending(pathComponent: "admin")
            .appending(pathComponent: "permissions")
            .appending(parameter: "key")
            .appending(pathComponent: "edit")

        #expect(route.pattern == "/admin/permissions/{key}/edit")
    }

    @Test
    func resolvesParameterAsSingleEncodedPathComponent() throws {
        let route = WebRoute.root
            .appending(pathComponent: "admin")
            .appending(parameter: "key")

        #expect(
            try route.path(parameters: ["key": "some/key value"])
                == "/admin/some%2Fkey%20value/"
        )
    }

    @Test
    func reportsMissingRouteParameter() {
        let route = WebRoute.root.appending(parameter: "id")

        #expect(throws: WebRoute.ResolutionError.missingParameter("id")) {
            try route.path(parameters: [:])
        }
    }

    @Test
    func rootRouteResolvesToSlash() throws {
        #expect(WebRoute.root.pattern == "/")
        #expect(WebRoute.root.path == "/")
    }

    @Test
    func providesHummingbirdAndSlashTerminatedRepresentations() throws {
        let route = WebRoute.root
            .appending(pathComponent: "admin")
            .appending(parameter: "key")

        #expect(route.routerPath.description == "/admin/{key}")
        #expect(route.path == "/admin/{key}/")
        #expect(
            try route.path(parameters: ["key": "a/b"])
                == "/admin/a%2Fb/"
        )
        #expect(route.path(parameter: "key", value: "a/b") == "/admin/a%2Fb/")
    }
}
