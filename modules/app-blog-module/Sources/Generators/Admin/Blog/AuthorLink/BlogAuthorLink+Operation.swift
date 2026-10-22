import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink {
    protocol Operation: BearerProtectedOperation {}
}

extension BlogAuthorLink.Operation {
    var tags: [any TagRepresentable] { [BlogAuthorLinkTag()] }
}

extension BlogAuthorLink.Menu {
    protocol Operation: BlogAuthorLink.Operation {}
}

extension BlogAuthorLink.Menu.Operation {
    var parameters: [any ParameterRepresentable] {
        [BlogAuthorLinkMenuIdParameter().reference()]
    }
}

extension BlogAuthorLink.ID {
    protocol Operation: BlogAuthorLink.Menu.Operation {}
}

extension BlogAuthorLink.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [
            BlogAuthorLinkMenuIdParameter().reference(),
            BlogAuthorLinkIdParameter().reference(),
        ]
    }
}
