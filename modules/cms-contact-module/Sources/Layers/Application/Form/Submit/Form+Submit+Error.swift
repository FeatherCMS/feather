public import ContactModule
public import FeatherApplication

extension Form.Submit {
    public enum Error: UseCaseError {
        case formNotFound
        case invalidValues(String)
    }
}
