import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Account invitation response"
        var schema = Invitation.Schemas.Detail().reference()
    }
}
