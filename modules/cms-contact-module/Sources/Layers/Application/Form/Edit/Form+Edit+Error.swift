public import ContactModule
public import FeatherApplication

extension Form.Edit {
    public enum Error: UseCaseError {
        case formNotFound
    }
}
