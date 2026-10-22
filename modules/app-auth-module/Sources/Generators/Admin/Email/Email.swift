import FeatherOpenAPI
import FeatherOpenAPIGenerator

enum Email {
    protocol Operation: BearerProtectedOperation {}

    enum Query {
        enum Schemas {}
    }
    enum Post {}
    enum Delete {}
    enum List {}
    enum Get {}
    enum Patch {}
    enum ID {}
    enum Schemas {}
    enum Parameters {}
}

extension Email.Operation {
    var tags: [any TagRepresentable] { [Email.Tag()] }
}

extension Email {
    struct Tag: TagRepresentable {
        var name: String = "AuthEmails"
    }
}
