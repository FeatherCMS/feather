public import FeatherApplication
public import ContactModule

extension Form.Submit {
    public enum Error: UseCaseError {
        case formNotFound
        case invalidValues(String)
    }
}
