struct AdminManageContactFormItem: Sendable {
    let id: String
    let name: String
}

struct ContactFormEditForm: Decodable {
    let name: String
}
