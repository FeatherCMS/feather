import FeatherOpenAPI

extension Email.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthEmailGetResponse" }
        var description: String = "Auth email response"
        var schema = Email.Get.Schema().reference()
    }
}
