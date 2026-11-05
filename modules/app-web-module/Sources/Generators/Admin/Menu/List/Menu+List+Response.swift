import FeatherOpenAPI

extension Menu.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MenuListResponse" }
        var description: String = "Menu list response"
        var schema = Schema().reference()
    }
}
