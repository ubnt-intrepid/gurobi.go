# Gurobi Interfaces for Golang

Unofficial Gurobi Interfaces for Golang.

(inspired by https://github.com/JuliaOpt/Gurobi.jl)

## Installation

Warning: The setup script is designed to only work on Mac OS X. If you are interested in using this on a Windows machine, then there are no guarantees that it will work.

### Installation in Module

1. Use a "-d" `go get -d github.com/kwesiRutledge/gurobi.go/gurobi`. Pay attention to which version appears in your terminal output.
2. Enter Go's internal installation of gurobi.go. For example, run `cd ~/go/pkg/mod/github.com/kwesi\!rutledge/gurobi.go@v0.0.0-20220103225839-e6367b1d0f27` where the suffix is the version number from the previous output.
3. Run go generate with sudo privileges from this installation. `sudo go generate`.

### Development Installation

1. Clone the library using `git clone github.com/kwesiRutledge/gurobi.go `
2. Run the setup script from inside the cloned repository: `go generate`.



## Usage

See the `testing` directory for some examples of how to use this.

Works in progress...



## LICENSE
See [LICENSE](LICENSE).
