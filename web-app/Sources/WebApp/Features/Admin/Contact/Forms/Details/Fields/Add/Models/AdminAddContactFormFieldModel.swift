struct AdminAddContactFormFieldModel: Sendable {
    let formId: String
    let key: String
    let type: String
    let label: String
    let allowedValues: String
    let isRequired: Bool
    let position: String
    let error: String?
}
