# cps350-2022-p3-white-cha

Clearer Details found on:
https://docs.google.com/document/d/1L1lTT5s4PpoyO7_Rug3l--hGIT8G_M_k-BcTsP8IRyo/edit?usp=sharing

Chat/Messaging app that allows for anonymous live chatting with operators at both CTS Help Desk & other campus services to respond to work requests (an alternative to phone calls). This is beneficial as often, tickets/calls could be solved with a simple chat message rather than a call. Furthermore, an operator could respond to multiple messages at the same time thus streamlining the process. Any case that is unable to be handled by a message can be written up as a ticket to be pushed down the line. 


Target Users:
CTS Help Desk (work requests)
SFS (requests)


API/Services:
CryptoKit (for end to end encryption)
Firebase Database

Resources Used for Crypto Kit:
- https://developer.apple.com/documentation/cryptokit
  - Used throughout the entire development cycle for the cryptography functions, every third party code snippet was checked with the Apple documentation to both understand and use the code correctly
- https://betterprogramming.pub/how-to-set-up-end-to-end-encryption-in-an-ios-app-using-apples-cryptokit-e94815652e9c
  - Helpful starting point for how the different Cryptography pieces work together
- https://getstream.io/blog/ios-cryptokit-framework-chat/
  - Really nice code here with good error checking that we found very late but was not far off at all from what we had written, so we modified it for our needs using it as a template
- All documentation for the functions was completed by us as well as the actual use of the Cryptography functions in our demo

