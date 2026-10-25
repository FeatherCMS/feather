import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File {
    protocol Operation: BearerProtectedOperation {}
    protocol IDOperation: Operation {}
}

extension Asset.File.Operation {
    var tags: [any TagRepresentable] { [Asset.File.Tag()] }
}

extension Asset.File.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [Asset.File.Parameters.ID().reference()]
    }
}
