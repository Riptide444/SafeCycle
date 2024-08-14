//
//  MQTTManager.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 8/7/24.
//

import Foundation
import CocoaMQTT

class MQTTManager: ObservableObject {
    private var mqtt: CocoaMQTT!

    @Published var receivedMessage: String = ""
    @Published var carBack: Bool = false

    init() {
        // Configure the MQTT client
        mqtt = CocoaMQTT(clientID: "iOS_Device", host: "10.85.254.171", port: 1883)
        mqtt.username = "" // Optional
        mqtt.password = "" // Optional
        mqtt.keepAlive = 60

        mqtt.didReceiveMessage = { mqtt, message, id in
            print("Received message: \(message.string ?? "No message") on topic: \(message.topic)")
            DispatchQueue.main.async {
                if message.string == "carback" {
                    self.carBack = true
                    print("carback true")
                }
            }
        }

        mqtt.didConnectAck = { mqtt, ack in
            print("MQTT didConnectAck: \(ack)")
            if ack == .accept {
                // Subscribe to the topic after a successful connection
                self.subscribe(to: "safecycle")
            }
        }

        mqtt.didDisconnect = { mqtt, error in
            if let error = error {
                print("MQTT didDisconnect: \(error.localizedDescription)")
            } else {
                print("MQTT didDisconnect: Normal disconnection")
            }
        }

        mqtt.connect()
    }

    func publish(message: String, topic: String) {
        guard mqtt.connState == .connected else {
            print("MQTT connection lost, attempting to reconnect...")
            reconnectAndPublish(message: message, topic: topic)
            return
        }
        
        let result = mqtt.publish(topic, withString: message)
        print("Publish result: \(result)")
    }

    private func reconnectAndPublish(message: String, topic: String) {
        mqtt.connect()

        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            if self.mqtt.connState == .connected {
                let result = self.mqtt.publish(topic, withString: message)
                print("Publish result after reconnect: \(result)")
            } else {
                print("Failed to reconnect, will not publish message.")
            }
        }
    }

    func subscribe(to topic: String) {
        mqtt.subscribe(topic)
    }
    
    func changeDirection(newDirection nDir: Direction?) {
        if let nDir {
            if nDir == .left {
                publish(message: "left", topic: "safecycle")
            } else if nDir == .right {
                publish(message: "right", topic: "safecycle")
            } else if nDir == .stop {
                publish(message: "stop", topic: "safecycle")
            }
        } else {
            publish(message: "on", topic: "safecycle")
        }
    }
}
