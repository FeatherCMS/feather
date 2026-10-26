import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post {
    protocol Operation: BearerProtectedOperation {}
}

extension Post.Operation {
    var tags: [any TagRepresentable] { [Post.Tag()] }
}

extension Post.ID {
    protocol Operation: Post.Operation {}
}

extension Post.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [Post.Parameters.ID().reference()]
    }
}
