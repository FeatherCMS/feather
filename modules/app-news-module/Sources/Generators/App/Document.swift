import FeatherOpenAPI
import FeatherOpenAPIGenerator
import NewsSharedOpenAPIGenerator
import OpenAPIKit30

struct Info: InfoRepresentable {
    var title: String { "News App API" }
    var version: String { "0.1.0" }
}

struct TestServer: ServerRepresentable {
    var url: any LocationRepresentable { Location("http://127.0.0.1:8080/") }
}

struct Document: DocumentRepresentable {
    var info: OpenAPIInfoRepresentable = Info()
    var servers: [any OpenAPIServerRepresentable] { [TestServer()] }
    var paths: PathMap = PathCollection().pathMap
    var components: OpenAPIComponentsRepresentable = PathCollection().components
}
