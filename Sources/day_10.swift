import Foundation

class Day10: Day {
    let log: Bool

    init(log: Bool = false) {
        self.log = log
    }
    
    class Evolutions {
        var evolutions: [Evolution] = []
        var log: Bool = false

        init(numbers: [Int]) {
            for num in numbers {
                evolutions.append(Evolution(number: num))
            }
        }
        
        func evolve() {
            var nextEvolutions: [Int: Evolution] = [:]
            for evolution in evolutions {
                let evolveds = evolution.evolve()
                for evolved in evolveds {
                    if let alrAdded = nextEvolutions[evolved.number] {
                        alrAdded.factor += evolved.factor
                    }else{
                        nextEvolutions[evolved.number] = evolved
                    }
                }
            }
            evolutions = Array(nextEvolutions.values)
            if log {
                print("evolution completed:")
                for evol in evolutions {
                    print("\(evol)")
                }
                print("-------------")
            }
        }
        var count: Int {
            var cnt = 0
            for evol in evolutions {
                cnt += evol.factor
            }
            return cnt
        }
    }
    class Evolution: CustomStringConvertible {
        var number: Int
        var factor: Int

        init(number: Int) {
            self.number = number
            factor = 1
        }
        init(number: Int, factor: Int){
            self.number = number
            self.factor = factor
        }
        func evolve() -> [Evolution] {
            // print("evolve: \(number)")
            if isEvenlySplittable(number) {
                let splits = splitNumbers()
                return Array(splits.map{Evolution(number: $0, factor: factor)})
            }else{
                switch number {
                    case 0: number = 1
                    default: number = number * 2024
                }
            }
            return [self]
        }
        func splitNumbers() -> [Int] {
            let numStr = number < 10 ? "0\(number)" : String(number)
            // print("num: \(number), numStr: \(numStr)")
            let half = numStr.count / 2
            let leftVal = Int(String(numStr.prefix(half)))!
            let rightVal = Int(String(numStr.suffix(half)))!
            return [leftVal, rightVal]
        }
        func isEvenlySplittable(_ val: Int) -> Bool {
            let divisor = val - val % 10
            if divisor == 0 {
                return false
            }
            let result = (Int(log10(Double(val - val % 10))) % 2) == 1
            return result
        }
        var description: String {
            return "Evol(num: \(number), factor: \(factor))"
        }
    }
    func processEvolutions(_ evolutions: Evolutions, from start: Int, until end: Int) {
        for i in start..<end {
            evolutions.evolve()
            if log { print("blinked \(i+1) times") }
        }
    }
    func eval() -> (Int, Int) {
        let numbers = parsePuzzle(puzzle_10)
        let evolutions = Evolutions(numbers: numbers)
        evolutions.log = log

        processEvolutions(evolutions, from: 0, until: 25)
        let part1 = evolutions.count

        processEvolutions(evolutions, from: 25, until: 75)
        let part2 = evolutions.count
        
        if log { print("evolutions.count: \(evolutions.evolutions.count)") }
        
        return (part1, part2)
    }
    func parsePuzzle(_ puzzle: String) -> [Int] {
        var numbers: [Int] = []
        for num in puzzle.split(separator: " ") {
            numbers.append( Int(num)! )
        }
        // print("puzzle numbers: ", numbers)
        return numbers
    }
}
let puzzle_10 = "2 77706 5847 9258441 0 741 883933 12"