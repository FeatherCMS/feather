import FeatherOpenAPI

extension Rule.Schemas {
    struct StatusCode: IntSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectStatusCodeField" }
        var enumValues: [Int]? = [301, 302, 307, 308]
        var example: Int? = 301
    }
}
