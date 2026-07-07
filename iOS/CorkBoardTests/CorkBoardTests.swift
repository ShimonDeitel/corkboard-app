import XCTest
@testable import CorkBoard

@MainActor
final class CorkBoardTests: XCTestCase {
    var store: CorkBoardStore!

    override func setUp() {
        super.setUp()
        store = CorkBoardStore()
    }

    func testSeedDataLoadedOnFreshInstall() {
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testSeedCountIsBelowFreeLimit() {
        XCTAssertLessThan(CorkBoardStore.seedData().count, CorkBoardStore.freeLimit)
    }

    func testAddEntrySucceedsUnderLimit() {
        let before = store.entries.count
        let added = store.add(BottleEntry(name: "Test Entry", detail: "Detail", date: Date()))
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddEntryFailsAtLimit() {
        while store.canAddMore {
            store.add(BottleEntry(name: "Filler", detail: "x", date: Date()))
        }
        let added = store.add(BottleEntry(name: "Overflow", detail: "x", date: Date()))
        XCTAssertFalse(added)
        XCTAssertEqual(store.entries.count, CorkBoardStore.freeLimit)
    }

    func testDeleteEntry() {
        let entry = BottleEntry(name: "ToDelete", detail: "x", date: Date())
        store.add(entry)
        let before = store.entries.count
        store.delete(entry)
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testUpdateEntry() {
        var entry = BottleEntry(name: "Original", detail: "x", date: Date())
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.name, "Updated")
    }

    func testToggleFavorite() {
        let entry = BottleEntry(name: "Fav", detail: "x", date: Date())
        store.add(entry)
        store.toggleFavorite(entry)
        XCTAssertTrue(store.entries.first(where: { $0.id == entry.id })?.isFavorite ?? false)
    }

    func testCanAddMoreReflectsLimit() {
        XCTAssertTrue(store.canAddMore)
    }
}
