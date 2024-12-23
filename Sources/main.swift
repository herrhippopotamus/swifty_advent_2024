import Foundation

logDay(day: 1, result: day1())
logDay(day: 2, result: day2())
logDay(day: 3, result: try Day3().eval())
logDay(day: 6, result: try Day6(log: false).eval())

func logDay(day: UInt8, result: (Int, Int)) {
    print(String(format: "Day \(day) - result 1: \(result.0), result 2: \(result.1)"))
}
// testPerformance()


func testPerformance() {
    var runtimeAvg = Double(0)
    let runs = 1_000
    // let day1 = Day01()
    for run in 0..<runs {
        let start = Date()
        let (d10, d11) = day1()
        let elapsed = Date().timeIntervalSince(start)
        runtimeAvg += Double(elapsed)
        print(String(format: "run[%d / %d]: Day 1 - result 1: %d, result 2: %d - elapsed: %.3f ms", run, runs, d10, d11, elapsed * 1000))
    }
    print(String(format: "Elapsed on average: %.3f ms", runtimeAvg / Double(runs) * 1000))
}


