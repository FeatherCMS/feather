public import FeatherApplication
public import ContactModule

extension Form.Public.Detail {
    public enum Error: UseCaseError {
        case formNotFound
    }
}
