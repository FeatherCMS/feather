import FeatherBackend
import Testing

@Suite
struct UpdateMaskTests {

    private enum Field: String, Sendable {
        case name
        case notes
        case value
    }

    @Test
    func parsesAndTrimsCommaSeparatedFields() throws {
        let mask = try UpdateMask<Field>("name, notes")

        #expect(mask.contains(.name))
        #expect(mask.contains(.notes))
        #expect(!mask.contains(.value))
    }

    @Test
    func deduplicatesRepeatedFields() throws {
        let mask = try UpdateMask<Field>("name,name")

        #expect(mask.contains(.name))
        #expect(!mask.contains(.notes))
    }

    @Test
    func rejectsEmptyAndUnknownFields() {
        #expect(throws: UpdateMask<Field>.ParsingError.empty) {
            try UpdateMask<Field>("")
        }
        #expect(throws: UpdateMask<Field>.ParsingError.invalidField("")) {
            try UpdateMask<Field>("name,,notes")
        }
        #expect(throws: UpdateMask<Field>.ParsingError.invalidField("other")) {
            try UpdateMask<Field>("name,other")
        }
    }
}
