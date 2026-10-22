import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile {
    protocol Operation: BearerProtectedOperation {}
}

extension Profile.Operation {
    var tags: [any TagRepresentable] { [Account.Tag()] }
    var parameters: [any ParameterRepresentable] {
        [Profile.Parameters.UserID().reference()]
    }
}

extension Profile.CurrentUser {
    protocol Operation: BearerProtectedOperation {}
}

extension Profile.CurrentUser.Operation {
    var tags: [any TagRepresentable] { [Account.Tag()] }
}
