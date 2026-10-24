import FeatherOpenAPI

extension Job.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SystemJobResponse" }
        var description: String = "Worker job response"
        var schema = Schema().reference()
    }
}
