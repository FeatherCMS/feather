import ContactApplication
import ContactModule

extension ContactModule.Form.Edit {
    struct FieldsForm: Decodable {
        let fieldIds: [String]?
    }
}
