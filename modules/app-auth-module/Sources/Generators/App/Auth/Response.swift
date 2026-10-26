import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth {
    struct Response: JSONResponseRepresentable {
        var description: String = "Auth response"
        var schema = Schemas.Response().reference()
    }
}

extension Auth.Me {
    struct Response: JSONResponseRepresentable {
        var description: String = "Current user response"
        var schema = Auth.Schemas.Response().reference()
    }
}
