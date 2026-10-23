import ContactApplication
import ContactModule

extension Submission.Edit {
    struct StatusForm: Decodable {
        let status: String
    }
}
