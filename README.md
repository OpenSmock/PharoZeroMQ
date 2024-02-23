[![License](https://img.shields.io/github/license/OpenSmock/PharoZeroMQ.svg)](./LICENSE)
   
[![Pharo 11 CI](https://github.com/OpenSmock/PharoZeroMQ/actions/workflows/Pharo11CI.yml/badge.svg)](https://github.com/OpenSmock/PharoZeroMQ/actions/workflows/Pharo11CI.yml)
[![Pharo 12 CI](https://github.com/OpenSmock/PharoZeroMQ/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/PharoZeroMQ/actions/workflows/Pharo12CI.yml)

# PharoZeroMQ

This is a framework of ZeroMQ (ZMQ, ØMQ or 0MQ) on Pharo. Using ZMQ lets you create a connection between 2 images via an URL and eventually send messages to one another. You will find the bases of the library, but some methods might be missing as well as some constants options. You'll find in ZMQ-Samples examples on how to use certain methods to guide you.

### What's to improve
+ _Receiving in a blocking way_ : To do that, a Threaded Worker needs to be used but every socket type doesn't necessarily support it. In this case, none of the implemented sockets can support multi-threading.

+ _Get Socket Option_ : This method doesn't seem to work, the error obtaineed is : 'Ressource Temporarily Unavailable' no matter what was tried regarding the types of arguments.

+ _Set Socket Option_ : Works with ByteArrays, so the use of ZMQ_SUBSCRIBE and UNSUBSCRIBE is possible as well as for other options that take same types arguments. There is however the same issue as with getsockopt for any other type requested by the method.

## Getting Started

### Installation

To install the project on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'PharoZeroMQ';
   repository: 'github://OpenSmock/PharoZeroMQ:main/src';
   load.
```

## Dependencies

No dependencies.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
