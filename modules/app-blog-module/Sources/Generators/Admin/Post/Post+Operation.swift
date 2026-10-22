import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post {
    protocol Operation: BearerProtectedOperation {}
}

extension Post.Operation {
    var tags: [any TagRepresentable] { [BlogPostTag()] }
}

extension Post.ID {
    protocol Operation: Post.Operation {}
}

extension Post.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [BlogPostIdParameter().reference()]
    }
}
