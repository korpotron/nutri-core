import Testing
@testable import NutriCore
@testable import NutriData

@Suite struct MineralsTests {
    @Test func test_zinc() {
        let sut = Mineral.zinc
        #expect(sut.name == "zinc")
    }

    @Test func test_all() {
        let sut = Mineral.allCases
        #expect(sut.count == 14)
    }
}
