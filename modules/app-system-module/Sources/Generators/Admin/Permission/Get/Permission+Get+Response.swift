import FeatherOpenAPI

extension Permission.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SystemPermissionDetailResponse" }
        var description: String = "SystemPermission response"
        var schema = Schema().reference()
    }
}
