import FeatherOpenAPI

struct ContactFormResponse: JSONResponseRepresentable {
    var description: String = "Contact form response"
    var schema = ContactFormSchema().reference()
}
struct ContactFormListResponse: JSONResponseRepresentable {
    var description: String = "Contact form list response"
    var schema = ContactFormListSchema().reference()
}
