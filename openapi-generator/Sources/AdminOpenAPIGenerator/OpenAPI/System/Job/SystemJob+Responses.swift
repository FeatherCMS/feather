import FeatherOpenAPI

struct SystemJobListResponse: JSONResponseRepresentable {
    var description: String = "Worker job list response"
    var schema = SystemJobListSchema().reference()
}

struct SystemJobResponse: JSONResponseRepresentable {
    var description: String = "Worker job response"
    var schema = SystemJobSchema().reference()
}
