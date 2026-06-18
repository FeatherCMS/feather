import Application
import NanoID

struct NanoIDGenerator: IDGenerator {
    func generate() -> String {
        NanoID().rawValue
    }
}
