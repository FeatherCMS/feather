public import ContactModule
public import FeatherDomain

extension SubmissionMail {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func listBy(formId: String) async throws -> [Model]
            func insert(_ model: Model.New) async throws -> Model
            func deleteBy(formId: String) async throws
        }
    }
}
