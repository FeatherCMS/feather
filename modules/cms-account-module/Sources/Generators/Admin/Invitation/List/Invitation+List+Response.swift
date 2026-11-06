import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Account invitation list response"
        var schema = Schema().reference()
    }
}
