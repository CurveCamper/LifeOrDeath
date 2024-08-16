//
//  ContentView.swift
//  LifeOrDeath
//
//  Created by Viktor on 16.08.2024.
//
import SwiftUI

struct ContentView: View {
    @State private var cells: [Cell] = []
    @State private var liveCount: Int = 0
    @State private var deadCount: Int = 0

    var body: some View {
        VStack {
            Text("Клеточное наполнение")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.white)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(cells) { cell in
                            CellView(cell: cell)
                        }
                    }
                    .padding()
                    //автоматическая прокрутка
                    .onChange(of: cells) { _ in
                        if let lastCellID = cells.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastCellID, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            Button(action: {
                addNewCell()
            }) {
                Text("СОТВОРИТЬ")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.3777335286, green: 0.1904184818, blue: 0.4615837336))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding([.horizontal, .bottom], 10)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color(#colorLiteral(red: 0.1859337389, green: 0, blue: 0.2928575277, alpha: 1))]), startPoint: .bottom, endPoint: .top))
    }

    private func addNewCell() {
        let newCellType = Bool.random() ? CellType.dead : CellType.live

        if newCellType == .live {
            liveCount += 1
            deadCount = 0
        } else {
            deadCount += 1
            liveCount = 0
        }

        if liveCount == 3 {
            cells.append(Cell(type: newCellType))
            cells.append(Cell(type: .life))
            liveCount = 0
        } else {
            cells.append(Cell(type: newCellType))
        }

        if deadCount == 3 {
            if let lastLifeIndex = cells.lastIndex(where: { $0.type == .life }) {
                cells.remove(at: lastLifeIndex)
            }
            deadCount = 0
        }
    }
}

struct CellView: View {
    let cell: Cell
    
    var body: some View {
        HStack {
            Image(cell.iconName)
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .padding()
            
            VStack(alignment: .leading) {
                Text(cell.title)
                    .foregroundStyle(.black)
                    .font(.headline)
                Text(cell.subtitle)
                    .foregroundStyle(.black)
                    .font(.subheadline)
            }
            Spacer()
        }
        .frame(height: 60)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

enum CellType {
    case dead, live, life
}

struct Cell: Identifiable, Equatable {
    let id = UUID()
    let type: CellType
    
    var title: String {
        switch type {
        case .dead: return "Мёртвая"
        case .live: return "Живая"
        case .life: return "Жизнь"
        }
    }
    
    var subtitle: String {
        switch type {
        case .dead: return "или прикидывается"
        case .live: return "и шевелится!"
        case .life: return "Ку-ку!"
        }
    }
    
    var iconName: String {
        switch type {
        case .dead: return "skull"
        case .live: return "boom"
        case .life: return "live"
        }
    }

    // функция для автоматической прокрутки
    static func ==(lhs: Cell, rhs: Cell) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
