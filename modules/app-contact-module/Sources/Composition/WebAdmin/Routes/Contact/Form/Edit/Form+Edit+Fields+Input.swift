import ContactApplication
import ContactModule

extension ContactModule.Form.Edit.Fields {
    struct Input: Decodable {
        let fieldIds: [String]?
    }
}
