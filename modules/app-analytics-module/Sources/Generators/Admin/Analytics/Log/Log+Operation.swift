import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log {
    protocol Operation: BearerProtectedOperation {}
    protocol IdentifiableOperation: Operation {}
}

extension Analytics.Log.Operation {
    var tags: [any TagRepresentable] { [Analytics.Log.Tag()] }
}

extension Analytics.Log.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [Analytics.Log.Parameters.ID().reference()]
    }
}
