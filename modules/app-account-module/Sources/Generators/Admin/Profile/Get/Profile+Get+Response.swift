import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AccountProfileResponse" }
        var description: String = "Account profile response"
        var schema = Schema().reference()
    }
}
