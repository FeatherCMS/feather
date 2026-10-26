import FeatherOpenAPI

extension Permission.List {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SystemPermissionListResponse" }
        var description: String = "SystemPermission list response"
        var schema = Schema().reference()
    }

}
