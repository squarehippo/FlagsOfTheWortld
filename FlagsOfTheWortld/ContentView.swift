//
//  ContentView.swift
//  FlagsOfTheWortld
//
//  Created by Brian Wilson on 5/10/21.
//

import SwiftUI

struct FlagImage: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            .shadow(radius: 7)
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var message = ""
    @State private var userScore = 0
    @State private var animationAmount = 0.0
    @State private var nextOpacity = 0.0
    @State private var offsetAmount: CGFloat = 80
    @State private var tapped = false
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        flagTapped(number)
                        tapped.toggle()
                    }) {
                        FlagImage(flag: countries[number])
                            .rotation3DEffect(.degrees((number == correctAnswer) ? animationAmount : 0.0), axis: (x: 1, y:0 , z: 0))
                            .opacity(number != correctAnswer && tapped ? 0.3 : 1.0)
                    }
                }
                Spacer()
                Text("Score: \(userScore)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            
            VStack {
                Spacer()
                Button(action: {
                    askQuestion()
                }) {
                    Text("NEXT")
                        .fontWeight(.black)
                        .frame(width: 300, height: 100)
                        .font(.system(size: 50))
                }
                .foregroundColor(.white)
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .opacity(nextOpacity)
                .offset(y: offsetAmount)
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            userScore += 1
            withAnimation(Animation.timingCurve(0.1, 0.1, 0.25, 0.99, duration: 1.5)) {
                self.animationAmount += 1440
            }
            withAnimation{
                self.offsetAmount = -80
            }
        } else {
            withAnimation {
                self.offsetAmount = -80
            }
        }
        showingScore = true
        nextOpacity = 1.0
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation {
            nextOpacity = 0.0
            offsetAmount = 80
            tapped = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
