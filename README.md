# HueGang Team - QPVC Smart warehouse manager app
This mobile app is the main app that we use in our business solution QPVC Smart warehouse. This app plays an important role in interacting with customers. Allowing customers to scan face and collect packages.
Face recognition and speech recognition are applied to create a contactless, non human-human interaction experience.
This app works along with a user tracking app that is also used to collect customer face data for identification purpose [https://github.com/vunguyen7797/QPVC-Tracking-App]
This app is developed by our team within 48 hours, so that it is not completed 100%, it is just a demo for the main features. To get to know more about how it works, please watch the "Smart warehouse solution idea" below.

## Face Recognition To Pick Up Parcel Demo
[![Watch the video](https://firebasestorage.googleapis.com/v0/b/qpv-face-scanner.appspot.com/o/client_app_screenshot%2FScreen%20Shot%202020-11-21%20at%208.40.29%20PM.png?alt=media&token=0d452ba0-69b0-4f5e-9771-1ac90e4c5d47)](https://youtu.be/bVpCCP49mBQ)

## QR Code Scanner Demo
[![Watch the video](https://firebasestorage.googleapis.com/v0/b/qpv-face-scanner.appspot.com/o/client_app_screenshot%2FScreen%20Shot%202020-11-21%20at%206.56.05%20PM.png?alt=media&token=98207c11-4587-4708-8cc5-0fa319fcb799)](https://youtu.be/VWfBsEeA8s4)

## QPVC Smart warehouse solution idea
[![Watch the video](https://firebasestorage.googleapis.com/v0/b/qpv-face-scanner.appspot.com/o/client_app_screenshot%2FScreen%20Shot%202020-11-21%20at%207.25.55%20PM.png?alt=media&token=3faa5632-2d9a-44c6-85e1-dc7f55197198)](https://youtu.be/DiAPua41We4)

# Team member
* Vu Nguyen
* Nguyen Hoang Quy
* Phuong Nguyen
* Phan Thien Chi

## Developer
* Vu Nguyen
* Nguyen Hoang Quy
* Phuong Nguyen

## Demo Features
* Face recognition detects face on a live-camera, then identify the customer's information.
* QR code scanner as a back up solution if face recognition has any issues.
* Speech recognition to recognize voice commands from customers.
* Tracking the parcels available for a customer as well as recycle points.

## Upcoming future features:
* Communicate with real mechanical systems via WIFI or Bluetooth.
* Update customers via notifications.
* Dashboard to manage the operation of the warehouse.

## Technologies:
* We use prebuilt model via Face API provided by Microsoft Cognitive Services to train and identify the customers.
* Google Vision is used to detect face in live camera.
* Google Cloud Firestore to store customers data and parcels data.
* Frontend framework: Flutter

![Image description](https://firebasestorage.googleapis.com/v0/b/qpv-face-scanner.appspot.com/o/client_app_screenshot%2Fwarehouse_diagram.png?alt=media&token=87a3ea03-a7ea-47d8-8d93-0325e9387961) 
![Image description](https://firebasestorage.googleapis.com/v0/b/qpv-face-scanner.appspot.com/o/client_app_screenshot%2FScreen%20Shot%202020-11-21%20at%208.54.04%20PM.png?alt=media&token=0e11ebab-75a0-45f0-a741-1589a4d3b7bc) 


