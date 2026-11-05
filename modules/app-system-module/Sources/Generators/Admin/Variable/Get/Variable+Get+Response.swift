import FeatherOpenAPI

extension Variable.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SystemVariableDetailResponse" }
        var description: String = "SystemVariable response"
        var schema = Schema().reference()
    }
}
