import SwiftUI

struct ExpandingView: View {
    @State var expanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring()) {
                    expanded.toggle()
                }
            } label: {
                Text("Button")
            }
                        
            Color.yellow
                .frame(height: expanded ? 300 : 0)
        }
        .padding(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

struct ContentView: View {
    @State var hello = false
    @State var hey = false
    
    var body: some View {
        ScrollView {
            TestStack {
                ExpandingView()
            }.background(Color.red)
        
            TestStack {
                ExpandingView().background(Color.green)
                
                Text("Fisken").background(Color.blue)
                
                if hello {
                    LazyVStack {
                        ForEach(0..<3000) { int in
                            Text(String(int))
                        }
                    }
                }
                
                OtherStack {
                    OtherStack {
                        ExpandingView()
                    }
                }.background(Color.yellow)
            }.background(Color.red)
            
            VStack(spacing: 0) {
                Button("Hello") {
                    withAnimation(.easeOut(duration: 0.3)) {
                        hello.toggle()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
