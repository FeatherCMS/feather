import FeatherApplication
import ContactModule

extension Form.Submit {
    public enum Error: UseCaseError {
        case formNotFound
        case invalidValues(String)
    }
}
