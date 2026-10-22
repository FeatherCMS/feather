import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost {
    protocol Operation: BearerProtectedOperation {}
}

extension BlogPost.Operation {
    var tags: [any TagRepresentable] { [BlogPostTag()] }
}

extension BlogPost.ID {
    protocol Operation: BlogPost.Operation {}
}

extension BlogPost.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [BlogPostIdParameter().reference()]
    }
}
