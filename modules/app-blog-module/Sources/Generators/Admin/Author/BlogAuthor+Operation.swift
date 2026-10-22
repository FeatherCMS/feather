import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor {
    protocol Operation: BearerProtectedOperation {}
}

extension BlogAuthor.Operation {
    var tags: [any TagRepresentable] { [BlogAuthorTag()] }
}

extension BlogAuthor.ID {
    protocol Operation: BlogAuthor.Operation {}
}

extension BlogAuthor.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [BlogAuthorIdParameter().reference()]
    }
}
