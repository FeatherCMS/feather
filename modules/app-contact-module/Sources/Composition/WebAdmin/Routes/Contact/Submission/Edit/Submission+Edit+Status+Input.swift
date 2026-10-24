import ContactApplication
import ContactModule

extension Submission.Edit.Status {
    struct Input: Decodable {
        let status: String
    }
}
