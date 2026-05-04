import SwiftUI
struct ContentView: View {
    //game state variables at the start
    @State private var score = 0
    @State private var pointsPerTap = 1
    
    //original upgrade costs
    @State private var strengthCost = 20 //cost to upgrade +1
    @State private var doubleCost = 150 //double cur power
    @State private var critChanceCost = 200 //+5% crit chance
    
    //critical hits
    @State private var critChance = 0.01 //original crit chance
    @State private var showCritText = false //show critical hit text
    
    
    var body: some View {
        VStack(spacing: 28) {
            
            Spacer()
            
            //score display
            Text("Score")
                .font(.title3)
                .bold()
            Text("\(score)")
                .font(.largeTitle)
                .bold()
            
            
            Spacer()
            
            //Main tapping button
            Button {
                handleTap() // Handles normal taps + critical hit stuff
            } label: {
                Text("+\(pointsPerTap)") //current tap strength
                    .font(.system(size: 40, weight: .bold))
                    .frame(width: 300, height: 180)
                    .background(Color.blue.opacity(0.85))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
            }
            
            //crit text, shows up if crit
            if showCritText {
                Text("CRITICAL HIT!")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
                    .transition(.opacity)
            }

            //upgrades
            VStack(spacing: 12) {
                Text("Upgrades")
                    .font(.title2)
                    .bold()
                
                //+1 strength
                UpgradeButton(
                    title: "Increase Strength (+1)",
                    cost: strengthCost, isAffordable: score >= strengthCost
                ) {
                    score -= strengthCost //pay for cost
                    pointsPerTap += 1 //increase strength
                    strengthCost = Int(Double(strengthCost) * 1.5) //scale costs
                }
                
                //double tap power
                UpgradeButton(
                    title: "Double Tap Power (x2)",
                    cost: doubleCost, isAffordable: score >= doubleCost
                ) {
                    
                    score -= doubleCost
                    pointsPerTap *= 2
                    doubleCost = Int(Double(doubleCost) * 2.5)
                }
                
                //crit upgrade
                UpgradeButton(
                    title: "Increase Crit Chance (+5%)",
                    cost: critChanceCost, isAffordable: score >= critChanceCost
                ) {
                    score -= critChanceCost //pay
                    critChance += 0.05
                    critChance = min(critChance, 0.75) //cap at 75%
                    critChanceCost = Int(Double(critChanceCost) * 3.5)
                }
            }
            .padding(.horizontal)
            
            Spacer()

        }
        .padding()
    }
    //tap handling
    func handleTap() {
        let isCrit = Double.random(in: 0...1) < critChance //dertermine crit
        
        //if crit --> power for that one tap is *3
        let tapValue = isCrit ? pointsPerTap * 3 : pointsPerTap
        score += tapValue //add points
        
        //if is crit, show text
        if isCrit {
            showCritText = true
            
        //hide the text after 0.6 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                showCritText = false
            }
        }
    }
}


//upgrade button
struct UpgradeButton: View {
    let title: String //text on button
    let cost: Int //upgrade cost
    let isAffordable: Bool //if player can afford
    let action: () -> Void //when button is pressed
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Text("Cost: \(cost)")
            }
            .padding()
            .background(isAffordable ? Color.green.opacity(0.85) : Color.gray.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!isAffordable) //prevents clicking if not enough score
    }
}

#Preview {
    ContentView()
}
