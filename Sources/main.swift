import Foundation

protocol Day {
    func eval() throws -> (Int, Int)
}

logDay(index: 1, day: Day1())
logDay(index: 2, day: Day2())
logDay(index: 3, day: try Day3())
logDay(index: 6, day: try Day6(log: false))
logDay(index: 7, day: Day7(log: false))
logDay(index: 8, day: Day8(log: false))

func logDay(index: UInt8, day: Day){
    let result = try! day.eval()
    print(String(format: "Day \(index) - 1st part: \(result.0), 2nd part: \(result.1)"))
}
// try testPerformance()


func testPerformance() throws {
    var runtimeAvg = Double(0)
    let runs = 1_000
    let day1 = Day1()
    for run in 0..<runs {
        let start = Date()
        let (d10, d11) = try day1.eval()
        let elapsed = Date().timeIntervalSince(start)
        runtimeAvg += Double(elapsed)
        print(String(format: "run[%d / %d]: Day 1 - 1st part: %d, 2nd part: %d - elapsed: %.3f ms", run, runs, d10, d11, elapsed * 1000))
    }
    print(String(format: "Elapsed on average: %.3f ms", runtimeAvg / Double(runs) * 1000))
}


