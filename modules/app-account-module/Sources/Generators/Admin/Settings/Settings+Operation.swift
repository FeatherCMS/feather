import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    protocol Operation: BearerProtectedOperation {}
}

extension Settings.Operation {
    var tags: [any TagRepresentable] { [Settings.Tag()] }
}

extension Settings.User {
    protocol Operation: Settings.Operation {}
}

extension Settings.User.Operation {
    var parameters: [any ParameterRepresentable] {
        [Settings.Parameters.UserID().reference()]
    }
}
