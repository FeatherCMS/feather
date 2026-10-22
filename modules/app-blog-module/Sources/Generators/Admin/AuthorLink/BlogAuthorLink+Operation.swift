import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink {
    protocol Operation: BearerProtectedOperation {}
}

extension BlogAuthorLink.Operation {
    var tags: [any TagRepresentable] { [BlogAuthorLinkTag()] }
}

extension BlogAuthorLink.Operation {
    var parameters: [any ParameterRepresentable] {
        [BlogAuthorLinkAuthorIdParameter().reference()]
    }
}

extension BlogAuthorLink.ID {
    protocol Operation: BlogAuthorLink.Operation {}
}

extension BlogAuthorLink.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [
            BlogAuthorLinkAuthorIdParameter().reference(),
            BlogAuthorLinkIdParameter().reference(),
        ]
    }
}
