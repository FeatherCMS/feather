import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder {
    protocol Operation: BearerProtectedOperation {}
    protocol IDOperation: Operation {}
}

extension Asset.Folder.Operation {
    var tags: [any TagRepresentable] { [MediaFolderTag()] }
}

extension Asset.Folder.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [MediaFolderIdParameter().reference()]
    }
}
