import FeatherOpenAPI

extension Variable.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SystemVariableListResponse" }
        var description: String = "SystemVariable list response"
        var schema = Schema().reference()
    }
}
