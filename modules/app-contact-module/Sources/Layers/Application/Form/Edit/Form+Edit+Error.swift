public import FeatherApplication
public import ContactModule

extension Form.Edit {
    public enum Error: UseCaseError {
        case formNotFound
    }
}
