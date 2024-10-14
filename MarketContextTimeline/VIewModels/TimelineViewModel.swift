//
//  TimelineViewModel.swift
//  MarketContextTimeline
//
//  Created by Ramon Ferreira on 10/10/24.
//

import Foundation
import Combine

final class TimelineViewModel {
    @Published var cards: [Card] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchCards() {
        // Simulate network fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let fetchCards = [
                Card(title: "Notice 1",
                     subtitle: "This is a sample notice to present the timeline, it can be a long text",
                     sourceNew: "my head",
                     assets: [ Asset(stockName: "MGLU3"),
                               Asset(stockName: "IBVV11"),
                               Asset(stockName: "BBSA3"),
                               Asset(stockName: "Hash Index Ethereum position replicated with a 100% accuracy")],
                     benchmarks: [ Benchmark(title: "IPCA", rentability: -2) ]),
                
                Card(title: "Notice 2",
                     subtitle: "Teste notice subtitle",
                     sourceNew: nil,
                     assets: [ Asset(stockName: "BBSA3") ],
                     benchmarks: [ Benchmark(title: "IPCA", rentability: -2),
                                   Benchmark(title: "CDI", rentability: 100),
                                   Benchmark(title: "Poupança", rentability: 50)]),
                
                Card(title: "Notice 3",
                     subtitle: "This is a sample notice to present the timeline, it can be a long text",
                     sourceNew: nil,
                     assets: nil,
                     benchmarks: [ Benchmark(title: "IPTU", rentability: -10) ])
            ]
            
            self.cards = fetchCards
        }
    }
}
