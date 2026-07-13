import Testing
@testable import ContactInfrastructure

@Suite
struct ContactInfrastructureTestSuite {

    @Test
    func infrastructureTargetLoads() {
        #expect(
            String(describing: ContactInfrastructureModule.self)
                .contains("ContactInfrastructureModule")
        )
    }
}
