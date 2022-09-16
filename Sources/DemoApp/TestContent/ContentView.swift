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
                Color.green
                Color.yellow
            }
            .frame(height: hello ? 200 : 300)
            .background(Color.red)
            
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
