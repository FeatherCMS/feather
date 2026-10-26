import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author {
    protocol Operation: BearerProtectedOperation {}
}

extension Author.Operation {
    var tags: [any TagRepresentable] { [Author.Tag()] }
}

extension Author.ID {
    protocol Operation: Author.Operation {}
}

extension Author.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [Author.Parameters.ID().reference()]
    }
}
