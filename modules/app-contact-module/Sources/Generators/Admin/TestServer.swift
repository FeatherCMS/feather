import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct TestServer: ServerRepresentable {
    var url: any LocationRepresentable {
        Location("http://127.0.0.1:8080/")
    }
}
