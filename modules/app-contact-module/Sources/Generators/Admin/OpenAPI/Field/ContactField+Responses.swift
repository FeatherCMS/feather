import FeatherOpenAPI

struct FormFieldResponse: JSONResponseRepresentable {
    var description: String = "Contact form field response"
    var schema = FormFieldSchema().reference()
}
struct FormFieldListResponse: JSONResponseRepresentable {
    var description: String = "Contact form field list response"
    var schema = FormFieldListSchema().reference()
}
