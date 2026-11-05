import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder {
    protocol Operation: BearerProtectedOperation {}
    protocol IDOperation: Operation {}
}

extension Asset.Folder.Operation {
    var tags: [any TagRepresentable] { [Asset.Folder.Tag()] }
}

extension Asset.Folder.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [Asset.Folder.Parameters.ID().reference()]
    }
}
