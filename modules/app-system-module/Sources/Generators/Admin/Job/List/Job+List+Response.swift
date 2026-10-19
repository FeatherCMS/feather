import FeatherOpenAPI

extension Job.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SystemJobListResponse" }
        var description: String = "Worker job list response"
        var schema = Schema().reference()
    }
}
