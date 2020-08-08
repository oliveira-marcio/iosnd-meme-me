# MemeMe

Second project of [Udacity's iOS Developer Nanodegree](https://www.udacity.com/course/ios-developer-nanodegree--nd003). It's a 2-part app where this first one will allow users to create memes from images from device's camera or album and share them.

To acomplish that it was required:

- `UIImagePickerController` to get images from device's album.
- `AVCaptureDevice` to get images from device's camera (when available).
- Subscription to `NotificationCenter` to observe showing/hidden events from keyboard to avoid bottom label being overlaped by it. 
- `view.drawHierarchy()` and `CGImage.cropping()` to capture screen and crop meme area.
- `UIActivityViewController` to share or locally save the generated images.

**Screenshots:**

<table align="center">
  <tr>
     <td>
       <img src="screenshots/image1.png" width="400" title="Main screen">
       <p align="center">Main screen</p>
     </td>
     <td>
       <img src="screenshots/image2.png" width="400" title="Label editing">
       <p align="center">Label editing</p>
     </td>
  </tr>
  <tr>
     <td>
       <img src="screenshots/image3.png" width="400" title="Meme sharing">
       <p align="center">Meme sharing</p>
     </td>
     <td>
       <img src="screenshots/image4.png" width="400" title="Meme saved">
       <p align="center">Meme saved</p>
     </td>
  </tr>
</table>

## Installation

Clone this repository, import into [Xcode](https://developer.apple.com/xcode/) and build it with simulator.

## Copyright

Project developed by Márcio Souza de Oliveira.
