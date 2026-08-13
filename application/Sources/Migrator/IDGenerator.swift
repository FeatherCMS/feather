import FeatherDomain
import NanoID

struct NanoIDGenerator: IDGenerator {
    func generate() -> String {
        NanoID().rawValue
    }
}
