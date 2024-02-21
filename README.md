[![License](https://img.shields.io/github/license/OpenSmock/ProjectName.svg)](./LICENSE)

<badges for only one tests script>
   
[![Tests](https://github.com/OpenSmock/ProjectName/actions/workflows/Tests.yml/badge.svg)](https://github.com/OpenSmock/ProjectName/actions/workflows/Tests.yml)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 12](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)

<badges for separated tests scripts>
   
[![Pharo 11 CI](https://github.com/OpenSmock/ProjectName/actions/workflows/Pharo11CI.yml/badge.svg)](https://github.com/OpenSmock/ProjectName/actions/workflows/Pharo11CI.yml)
[![Pharo 12 CI](https://github.com/OpenSmock/ProjectName/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/ProjectName/actions/workflows/Pharo12CI.yml)

# ProjectName
Project description here.

## Getting Started

### Installation

To install the project on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'ProjectName';
   repository: 'github://OpenSmock/ProjectName:main/src';
   load.
```

## Dependencies

No dependencies.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
