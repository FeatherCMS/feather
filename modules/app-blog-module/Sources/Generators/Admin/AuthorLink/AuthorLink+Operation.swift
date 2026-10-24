import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink {
    protocol Operation: BearerProtectedOperation {}
}

extension AuthorLink.Operation {
    var tags: [any TagRepresentable] { [BlogAuthorLinkTag()] }
}

extension AuthorLink.Operation {
    var parameters: [any ParameterRepresentable] {
        [AuthorLink.Parameters.AuthorID().reference()]
    }
}

extension AuthorLink.ID {
    protocol Operation: AuthorLink.Operation {}
}

extension AuthorLink.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [
            AuthorLink.Parameters.AuthorID().reference(),
            AuthorLink.Parameters.ID().reference(),
        ]
    }
}
